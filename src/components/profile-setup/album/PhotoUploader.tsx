import React, { useState } from 'react';
import { Camera, Upload, X, Plus, Lock } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { toast } from '@/hooks/use-toast';

interface PhotoUploaderProps {
  photos: string[];
  maxPhotos?: number;
  isPrivate?: boolean;
  onPhotosChange: (photos: string[]) => void;
}

const PhotoUploader: React.FC<PhotoUploaderProps> = ({
  photos,
  maxPhotos = 6,
  isPrivate = false,
  onPhotosChange
}) => {
  const [dragging, setDragging] = useState(false);
  
  const handleFileDrop = (e: React.DragEvent<HTMLDivElement>) => {
    e.preventDefault();
    setDragging(false);
    
    const files = e.dataTransfer.files;
    if (files.length === 0) return;
    
    handleFileUpload(files);
  };
  
  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const files = e.target.files;
    if (!files || files.length === 0) return;
    
    handleFileUpload(files);
    
    // Reset the input value so the same file can be selected again
    e.target.value = '';
  };
  
  const handleFileUpload = (files: FileList) => {
    // Check if adding these files would exceed the max
    if (photos.length + files.length > maxPhotos) {
      toast({
        title: `Maximum ${maxPhotos} photos allowed`,
        description: `You can only upload ${maxPhotos - photos.length} more photos`,
        variant: "destructive",
      });
      
      // Only add as many as we can
      const allowedCount = maxPhotos - photos.length;
      if (allowedCount <= 0) return;
      
      const filesToAdd = Array.from(files).slice(0, allowedCount);
      addFiles(filesToAdd);
      return;
    }
    
    // Otherwise add all files
    addFiles(Array.from(files));
  };
  
  const addFiles = (files: File[]) => {
    // Only allow images
    const imageFiles = files.filter(file => file.type.startsWith('image/'));
    
    if (imageFiles.length === 0) {
      toast({
        title: "No valid images found",
        description: "Please upload images in JPG, PNG or GIF format",
        variant: "destructive",
      });
      return;
    }
    
    // Create URLs for the valid images
    const newPhotos = imageFiles.map(file => URL.createObjectURL(file));
    
    // Update the photos array
    onPhotosChange([...photos, ...newPhotos]);
    
    toast({
      title: `${newPhotos.length} photos added`,
      description: `Successfully added to your ${isPrivate ? 'private' : 'public'} album`,
    });
  };
  
  const removePhoto = (index: number) => {
    const updatedPhotos = [...photos];
    updatedPhotos.splice(index, 1);
    onPhotosChange(updatedPhotos);
    
    toast({
      title: "Photo removed",
      description: "The photo has been removed from your album",
    });
  };
  
  return (
    <div className="space-y-2">
      <div className="grid grid-cols-3 gap-2">
        {photos.map((photo, index) => (
          <div key={index} className="relative aspect-square rounded-md overflow-hidden group">
            <img 
              src={photo} 
              alt={`Photo ${index + 1}`}
              className="w-full h-full object-cover"
            />
            <button
              className="absolute top-1 right-1 bg-black/70 rounded-full p-1 opacity-0 group-hover:opacity-100 transition-opacity"
              onClick={() => removePhoto(index)}
            >
              <X className="h-4 w-4 text-white" />
            </button>
            
            {isPrivate && (
              <div className="absolute bottom-1 left-1 bg-black/70 rounded-full p-1">
                <Lock className="h-3 w-3 text-white" />
              </div>
            )}
          </div>
        ))}
        
        {photos.length < maxPhotos && (
          <div
            className={`aspect-square rounded-md border-2 border-dashed ${
              dragging ? 'border-purple-500 bg-purple-500/10' : 'border-gray-600'
            } flex flex-col items-center justify-center cursor-pointer`}
            onDragOver={(e) => {
              e.preventDefault();
              setDragging(true);
            }}
            onDragLeave={() => setDragging(false)}
            onDrop={handleFileDrop}
          >
            <label className="cursor-pointer w-full h-full flex flex-col items-center justify-center">
              <Plus className="h-8 w-8 text-gray-400 mb-1" />
              <span className="text-sm text-gray-400">
                {isPrivate ? 'Add private photo' : 'Add photo'}
              </span>
              <Input
                type="file"
                accept="image/*"
                multiple
                className="hidden"
                onChange={handleFileChange}
              />
            </label>
          </div>
        )}
      </div>
      
      <div className="flex items-center justify-between text-xs text-gray-400 px-1">
        <span>{photos.length} of {maxPhotos}</span>
        <div className="flex items-center space-x-1">
          <Camera className="h-3 w-3" />
          <span>Tap + to add photos</span>
        </div>
      </div>
    </div>
  );
};

export default PhotoUploader;
