
import React from 'react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { LucideIcon } from 'lucide-react';

interface UploadMediaButtonProps {
  icon: LucideIcon;
  label: string;
  acceptTypes: string;
  multiple?: boolean;
  onUpload: (event: React.ChangeEvent<HTMLInputElement>) => void;
  disabled?: boolean;
  variant?: "default" | "destructive" | "outline" | "secondary" | "ghost" | "link";
  size?: "default" | "sm" | "lg" | "icon";
  className?: string;
}

const UploadMediaButton: React.FC<UploadMediaButtonProps> = ({ 
  icon: Icon, 
  label, 
  acceptTypes, 
  multiple = false,
  onUpload,
  disabled = false,
  variant = "outline",
  size = "sm",
  className = ""
}) => {
  return (
    <div className="relative">
      <Button 
        type="button" 
        variant={variant}
        size={size}
        className={className}
        disabled={disabled}
      >
        <Icon className="mr-2 h-4 w-4" />
        {label}
      </Button>
      <Input
        type="file"
        accept={acceptTypes}
        multiple={multiple}
        className="absolute inset-0 opacity-0 cursor-pointer"
        onChange={onUpload}
        disabled={disabled}
      />
    </div>
  );
};

export default UploadMediaButton;
