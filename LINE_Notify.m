function status_code = LINE_Notify(token, msg)
% input->token: YOUR access token for LINE Notify
%        msg: your message

    arguments 
        token (:, :) char = ''    % Putting your token, it is useful fou you.
        msg (:, :) string = ""      % I recommend you putting some default message.
    end

    url = "https://notify-api.line.me/api/notify";
    
    opt = weboptions('HeaderFields', {'Authorization', ['Bearer ', token]});
    response = webwrite(url, 'message', msg, opt);
    status_code = response.status;
end