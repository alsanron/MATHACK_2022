function iqresult = InlineQueryResultDocument_T(id, title,  varargin)
% InlineQueryResultDocument_T Represents a link to a file. By default, this
% file will be sent by the user with an optional caption. Alternatively,
% you can use input_message_content to send a message with the specified
% content instead of the file. Currently, only .PDF and .ZIP files can be
% sent using this method.
%
% type	String	Type of the result, must be document
%
% id	String	Unique identifier for this result, 1-64 bytes
%
% title	String	Title for the result
%
% caption	String	Optional. Caption of the document to be sent, 0-1024
% characters after entities parsing
%
% parse_mode	String	Optional. Mode for parsing entities in the document
% caption. See formatting options for more details.
%
% caption_entities	Array of MessageEntity	Optional. List of special
% entities that appear in the caption, which can be specified instead of
% parse_mode
%
% document_url	String	A valid URL for the file
%
% mime_type	String	Mime type of the content of the file, either
% “application/pdf” or “application/zip”
%
% description	String	Optional. Short description of the result
%
% reply_markup	InlineKeyboardMarkup	Optional. Inline keyboard attached
% to the message
%
% input_message_content	InputMessageContent	Optional. Content of the
% message to be sent instead of the file
%
% thumb_url	String	Optional. URL of the thumbnail (jpeg only) for the file
%
% thumb_width	Integer	Optional. Thumbnail width
%
% thumb_height	Integer	Optional. Thumbnail height
%
iqresult = struct;
iqresult.type = 'document';
iqresult.id = id;
iqresult.title = title;
while ~isempty(varargin)
    switch lower(varargin{1})
        case 'caption'
            iqresult.caption = varargin{2};
        case 'parse_mode'
            iqresult.parse_mode = varargin{2};
        case 'caption_entities'
            iqresult.caption_entities = varargin{2};
        case 'document_url'
            iqresult.document_url = varargin{2};
        case 'mime_type'
            iqresult.mime_type = varargin{2};
        case 'description'
            iqresult.description = varargin{2};
        case 'reply_markup'
            iqresult.reply_markup = varargin{2};
        case 'input_message_content'
            iqresult.input_message_content = varargin{2};
        case 'thumb_url'
            iqresult.thumb_url = varargin{2};
        case 'thumb_width'
            iqresult.thumb_width = varargin{2};
        case 'thumb_height'
            iqresult.thumb_height = varargin{2};
        otherwise
            error(['Unexpected option: ' varargin{1}])
    end % switch
    varargin(1:2) = [];
end % while isempty
end