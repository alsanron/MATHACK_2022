function iqresult = InlineQueryResultCachedVideo_T(id, video_file_id,...
    title, varargin)
% InlineQueryResultCachedVideo_T - Represents a link to a video file stored
% on the Telegram servers. By default, this video file will be sent by the
% user with an optional caption. Alternatively, you can use
% input_message_content to send a message with the specified content
% instead of the video.
%
% type	String	Type of the result, must be video
% 
% id	String	Unique identifier for this result, 1-64 bytes
% 
% video_file_id	String	A valid file identifier for the video file
% 
% title	String	Title for the result
% 
% description	String	Optional. Short description of the result
% 
% caption	String	Optional. Caption of the video to be sent, 0-1024
% characters after entities parsing
% 
% parse_mode	String	Optional. Mode for parsing entities in the video
% caption. See formatting options for more details.
% 
% caption_entities	Array of MessageEntity	Optional. List of special
% entities that appear in the caption, which can be specified instead of
% parse_mode
% 
% reply_markup	InlineKeyboardMarkup	Optional. Inline keyboard attached
% to the message
% 
% input_message_content	InputMessageContent	Optional. Content of the
% message to be sent instead of the video
%
iqresult = struct;
iqresult.type = 'video';
iqresult.id = id;
iqresult.video_file_id = video_file_id;
iqresult.title = title;
while ~isempty(varargin)
    switch lower(varargin{1})
        case 'description'
            iqresult.description = varargin{2};
        case 'caption'
            iqresult.caption = varargin{2};
        case 'parse_mode'
            iqresult.parse_mode = varargin{2};
        case 'caption_entities'
            iqresult.caption_entities = varargin{2};
        case 'reply_markup'
            iqresult.reply_markup = varargin{2};
        case 'input_message_content'
            iqresult.input_message_content = varargin{2};
        otherwise
            error(['Unexpected option: ' varargin{1}])
    end % switch
    varargin(1:2) = [];
end % while isempty
end