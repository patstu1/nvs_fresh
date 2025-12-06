
import React from 'react';
import { Image as ImageIcon, Video, Lock, Eye } from 'lucide-react';

interface AlbumGridProps {
  images: string[];
  isPrivate?: boolean;
  onImageClick: (index: number) => void;
  onLockClick?: () => void;
}

const AlbumGrid: React.FC<AlbumGridProps> = ({ 
  images, 
  isPrivate = false,
  onImageClick,
  onLockClick
}) => {
  if (images.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center p-8 border border-dashed border-gray-600 rounded-md bg-black/20">
        <div className="bg-gray-800 rounded-full p-3 mb-3">
          {isPrivate ? (
            <Lock className="w-8 h-8 text-gray-400" />
          ) : (
            <ImageIcon className="w-8 h-8 text-gray-400" />
          )}
        </div>
        <p className="text-gray-400 text-center text-sm">
          {isPrivate 
            ? "Add private photos that others can request to see" 
            : "Add public photos to your profile"}
        </p>
      </div>
    );
  }

  return (
    <div className={`grid grid-cols-3 gap-1 ${isPrivate ? 'opacity-90' : ''}`}>
      {images.slice(0, 6).map((src, index) => (
        <div 
          key={index}
          className="relative aspect-square overflow-hidden rounded-md cursor-pointer"
          onClick={() => onImageClick(index)}
        >
          {src.includes('video') ? (
            <div className="relative w-full h-full bg-black">
              <video 
                src={src} 
                className="absolute inset-0 w-full h-full object-cover" 
                muted
              />
              <div className="absolute bottom-1 right-1 bg-black/70 rounded-full p-1">
                <Video className="w-3 h-3 text-white" />
              </div>
            </div>
          ) : (
            <img 
              src={src} 
              alt={`Album image ${index+1}`}
              className="w-full h-full object-cover"
            />
          )}
          
          {index === 0 && images.length > 6 && (
            <div className="absolute inset-0 bg-black/60 flex items-center justify-center">
              <span className="text-white font-bold text-xl">+{images.length - 5}</span>
            </div>
          )}
        </div>
      ))}
      
      {isPrivate && (
        <div 
          className="absolute inset-0 bg-black/60 flex items-center justify-center cursor-pointer"
          onClick={onLockClick}
        >
          <div className="flex flex-col items-center">
            <Lock className="w-8 h-8 text-white mb-2" />
            <p className="text-white text-center text-sm">Tap to request access</p>
          </div>
        </div>
      )}
    </div>
  );
};

export default AlbumGrid;
