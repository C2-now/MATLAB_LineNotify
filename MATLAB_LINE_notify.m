classdef MATLAB_LINE_notify < handle
    properties(Access = private)
        token
        uri
        header
        method
    end
    
    methods
        function obj = MATLAB_LINE_notify(t)
            obj.token = t;
            obj.uri = 'https://notify-api.line.me/api/notify';
            obj.header = matlab.net.http.HeaderField('Authorization', ['Bearer ', obj.token],...
                'Content-Type', 'multipart/form-data');
            obj.method = 'POST';
        end
        
        function status = notify(obj, msg, varargin)
            if nargin < 2
                msg = "This is a default message.";
            end
            switch nargin
                case 1
                    provider = matlab.net.http.io.MultipartFormProvider('message', msg);
                case 2
                    provider = matlab.net.http.io.MultipartFormProvider('message', msg);
                case 3
                    if class(varargin{1}) == "double"
                        sticker_ids = validate_stamp(varargin{1});
                        provider = matlab.net.http.io.MultipartFormProvider(...
                            'message', msg, 'stickerPackageId', string(sticker_ids(1)),...
                            'stickerId', string(sticker_ids(2)));
                    elseif or(class(varargin{1}) == "char", class(varargin{1}) == "string")
                        img_path = validate_img(varargin{1});
                        img = matlab.net.http.io.FileProvider(img_path);
                        provider = matlab.net.http.io.MultipartFormProvider(...
                            'message', msg, 'imageFile', img);
                    end
                case 4
                    if class(varargin{1}) == "double"
                        sticker_ids = validate_stamp(varargin{1});
                        img_path = validate_img(varargin{2});
                        img = matlab.net.http.io.FileProvider(img_path);
                    elseif or(class(varargin{1}) == "char", class(varargin{1}) == "string")
                        sticker_ids = validate_stamp(varargin{2});
                        img_path = validate_img(varargin{1});
                        img = matlab.net.http.io.FileProvider(img_path);
                    end
                    provider = matlab.net.http.io.MultipartFormProvider(...
                        'message', msg, 'imageFile', img,...
                        'stickerPackageId', string(sticker_ids(1)),...
                        'stickerId', string(sticker_ids(2)));
                otherwise
                    error("入力引数が多すぎます。")
            end
            request = matlab.net.http.RequestMessage(obj.method, obj.header, provider);
            resp = send(request, obj.uri);
            status = resp.StatusCode;
        end
    end
end

%%
function sticker_ids = validate_stamp(sticker_ids)
    if length(sticker_ids) ~= 2
        error("スタンプIDが不正です。スタンプパッケージID、スタンプIDの順になっているか確認してください")
    else
        if sticker_ids(1) > 4
            error("スタンプIDが不正です。スタンプパッケージID、スタンプIDの順になっているか確認してください")
        end
    end
end

function img_path = validate_img(img_path)
    name = strsplit(img_path, '.');
    if ~ismember(name(end), {'png', 'jpg', 'jpeg'})
        error("画像ファイルの拡張子が不正です。pngもしくはjpgであることを確認してください。")
    end
end

