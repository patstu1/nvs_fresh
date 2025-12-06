
import React, { useState } from 'react';
import { Camera, Image, Mic, SendHorizontal, MapPin, Smile } from 'lucide-react';
import { Spinner } from '@/components/ui/spinner';
import EmojiPicker from 'emoji-picker-react';
import soundManager from '@/utils/soundManager';
import { ChatOriginSection } from '@/services/chat/types';

interface ChatInputProps {
  newMessage: string;
  setNewMessage: (message: string) => void;
  handleSendMessage: (e: React.FormEvent) => void;
  handleUploadImage: (e: React.ChangeEvent<HTMLInputElement>) => void;
  handleEmojiSelect: (emoji: string) => void;
  handleSendYo?: () => void;
  handleSendLocation?: () => void;
  handleSendVoice?: () => void;
  isBlocked: boolean;
  uploadingImage: boolean;
  showEmojiPicker: boolean;
  setShowEmojiPicker: (show: boolean) => void;
  sectionOrigin?: ChatOriginSection;
}

const ChatInput: React.FC<ChatInputProps> = ({
  newMessage,
  setNewMessage,
  handleSendMessage,
  handleUploadImage,
  handleEmojiSelect,
  handleSendYo,
  handleSendLocation,
  handleSendVoice,
  isBlocked,
  uploadingImage,
  showEmojiPicker,
  setShowEmojiPicker,
  sectionOrigin = 'unknown'
}) => {
  const fileInputRef = React.useRef<HTMLInputElement>(null);

  const getSectionButtonColor = () => {
    switch (sectionOrigin) {
      case 'grid': return 'bg-[#0066FF] hover:bg-[#0066FF]/90';
      case 'now': return 'bg-[#FF3366] hover:bg-[#FF3366]/90';
      case 'connect': return 'bg-[#33FF99] hover:bg-[#33FF99]/90';
      case 'live': return 'bg-[#9933FF] hover:bg-[#9933FF]/90';
      default: return 'bg-yobro-blue hover:bg-yobro-blue/90';
    }
  };

  const handleYoButtonClick = () => {
    if (handleSendYo) {
      soundManager.play('yo');
      handleSendYo();
    }
  };

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-black bg-opacity-90 backdrop-blur-lg border-t border-gray-800 px-2 py-3 z-30">
      {showEmojiPicker && (
        <div className="absolute bottom-16 left-0 right-0 max-w-screen-md mx-auto px-4">
          <div className="bg-[#1A1A1A] rounded-lg p-1 shadow-lg border border-gray-700">
            <EmojiPicker
              onEmojiClick={(emojiData) => handleEmojiSelect(emojiData.emoji)}
              searchDisabled
              skinTonesDisabled
              width="100%"
              height={300}
              previewConfig={{ showPreview: false }}
              lazyLoadEmojis
            />
          </div>
        </div>
      )}
      
      <div className="flex items-center max-w-screen-md mx-auto">
        <div className="flex items-center space-x-2 mr-2">
          <button
            type="button"
            onClick={() => setShowEmojiPicker(!showEmojiPicker)}
            className="text-gray-300 hover:text-white rounded-full p-2"
            disabled={isBlocked}
          >
            <Smile className="w-6 h-6" />
          </button>
          
          <button
            type="button"
            onClick={() => fileInputRef.current?.click()}
            className="text-gray-300 hover:text-white rounded-full p-2"
            disabled={isBlocked || uploadingImage}
          >
            <Camera className="w-6 h-6" />
            <input 
              ref={fileInputRef}
              type="file"
              accept="image/*"
              onChange={handleUploadImage}
              className="hidden"
              disabled={isBlocked}
            />
          </button>
          
          {handleSendLocation && (
            <button
              type="button"
              onClick={handleSendLocation}
              className="text-gray-300 hover:text-white rounded-full p-2"
              disabled={isBlocked}
            >
              <MapPin className="w-6 h-6" />
            </button>
          )}
          
          {handleSendVoice && (
            <button
              type="button"
              onClick={handleSendVoice}
              className="text-gray-300 hover:text-white rounded-full p-2"
              disabled={isBlocked}
            >
              <Mic className="w-6 h-6" />
            </button>
          )}
        </div>
        
        <form onSubmit={handleSendMessage} className="flex-1 flex items-center">
          <input
            type="text"
            value={newMessage}
            onChange={(e) => setNewMessage(e.target.value)}
            placeholder={isBlocked ? "Unblock to message" : "Type a message..."}
            className="flex-1 bg-[#2A2A2A] text-white rounded-l-full py-2 px-4 outline-none"
            disabled={isBlocked}
          />
          
          {handleSendYo && (
            <button
              type="button"
              className="bg-black text-white font-bold px-3 py-2 border-r border-gray-700"
              onClick={handleYoButtonClick}
              disabled={isBlocked}
            >
              YO
            </button>
          )}
          
          <button
            type="submit"
            className={`${getSectionButtonColor()} text-white rounded-r-full p-2 disabled:opacity-50 disabled:cursor-not-allowed`}
            disabled={isBlocked || (!newMessage.trim() && !uploadingImage)}
          >
            {uploadingImage ? (
              <Spinner className="w-6 h-6" />
            ) : (
              <SendHorizontal className="w-6 h-6" />
            )}
          </button>
        </form>
      </div>
    </div>
  );
};

export default ChatInput;
