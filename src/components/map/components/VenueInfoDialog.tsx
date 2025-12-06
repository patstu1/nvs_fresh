
import React from 'react';
import { Button } from '@/components/ui/button';
import { Dialog, DialogContent } from '@/components/ui/dialog';
import { Badge } from '@/components/ui/badge';
import { Beer, Coffee, Music, Users, Clock, Star, X, MessageCircle, Camera } from 'lucide-react';
import { toast } from '@/hooks/use-toast';

interface Venue {
  id: string;
  name: string;
  type: 'bar' | 'club' | 'cafe' | 'cruise';
  description: string;
  userCount: number;
  popularityScore: number;
  isActive: boolean;
  openingHours: string;
  images: string[];
}

interface VenueInfoDialogProps {
  open: boolean;
  onOpenChange: (open: boolean) => void;
  venue: Venue | null;
  onCheckIn: (venueId: string) => void;
}

const VenueInfoDialog: React.FC<VenueInfoDialogProps> = ({ 
  open, 
  onOpenChange, 
  venue, 
  onCheckIn 
}) => {
  if (!venue) return null;

  const getVenueIcon = (type: 'bar' | 'club' | 'cafe' | 'cruise') => {
    switch (type) {
      case 'bar': return <Beer className="w-4 h-4" />;
      case 'club': return <Music className="w-4 h-4" />;
      case 'cafe': return <Coffee className="w-4 h-4" />;
      case 'cruise': return <Users className="w-4 h-4" />;
    }
  };

  const getVenueColor = (type: 'bar' | 'club' | 'cafe' | 'cruise') => {
    switch (type) {
      case 'bar': return 'bg-orange-500';
      case 'club': return 'bg-pink-500';
      case 'cafe': return 'bg-green-500';
      case 'cruise': return 'bg-red-500';
    }
  };

  const handleCheckIn = () => {
    onCheckIn(venue.id);
    toast({
      title: "Checked In!",
      description: `You've checked in at ${venue.name}`,
    });
  };

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="bg-black border border-[#E6FFF4]/30 text-white max-w-md p-0 overflow-hidden">
        <div className="relative w-full h-48">
          {venue.images && venue.images.length > 0 ? (
            <img src={venue.images[0]} alt={venue.name} className="w-full h-full object-cover" />
          ) : (
            <div className="w-full h-full bg-gradient-to-br from-[#0F1828] to-[#1A2332] flex items-center justify-center">
              {getVenueIcon(venue.type)}
            </div>
          )}
          <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent" />
          
          <div className="absolute bottom-4 left-4 right-4">
            <div className="flex justify-between items-end">
              <div>
                <h2 className="text-2xl font-bold text-white">{venue.name}</h2>
                <div className="flex items-center mt-1">
                  <Badge className={`${getVenueColor(venue.type)} text-white flex items-center space-x-1`}>
                    {getVenueIcon(venue.type)}
                    <span className="ml-1 capitalize">{venue.type}</span>
                  </Badge>
                  <div className="ml-2 flex items-center">
                    <Star className="w-3 h-3 text-yellow-400" />
                    <span className="text-xs text-white ml-1">{venue.popularityScore}/10</span>
                  </div>
                </div>
              </div>
              
              <Badge className={venue.isActive ? 'bg-green-500 text-white' : 'bg-gray-500 text-white'}>
                {venue.isActive ? 'Active' : 'Quiet'}
              </Badge>
            </div>
          </div>
          
          <Button
            variant="ghost"
            size="icon"
            className="absolute top-2 right-2 text-white bg-black/50 rounded-full"
            onClick={() => onOpenChange(false)}
          >
            <X className="w-5 h-5" />
          </Button>
        </div>
        
        <div className="p-4">
          <div className="flex justify-between items-center mb-4">
            <div className="flex items-center">
              <Clock className="w-4 h-4 text-[#E6FFF4]/70 mr-1" />
              <span className="text-sm text-[#E6FFF4]/70">{venue.openingHours}</span>
            </div>
            <div className="flex items-center">
              <Users className="w-4 h-4 text-[#E6FFF4]/70 mr-1" />
              <span className="text-sm text-[#E6FFF4]/70">{venue.userCount} here now</span>
            </div>
          </div>
          
          <p className="text-sm text-[#E6FFF4]/90 mb-4">{venue.description}</p>
          
          {venue.images && venue.images.length > 1 && (
            <div className="mb-4">
              <h3 className="text-sm font-medium text-[#E6FFF4] mb-2">Photos</h3>
              <div className="flex space-x-2 overflow-x-auto pb-2">
                {venue.images.slice(1).map((img, idx) => (
                  <div key={idx} className="w-20 h-20 flex-shrink-0 rounded overflow-hidden">
                    <img src={img} alt={`${venue.name} ${idx + 1}`} className="w-full h-full object-cover" />
                  </div>
                ))}
              </div>
            </div>
          )}
          
          <div className="flex justify-between mt-4">
            <Button
              variant="outline"
              className="border-[#E6FFF4]/30 text-[#E6FFF4] flex-1 mr-2"
              onClick={() => {
                toast({
                  title: "Chat Started",
                  description: `Started venue chat for ${venue.name}`
                });
              }}
            >
              <MessageCircle className="w-4 h-4 mr-1" />
              Venue Chat
            </Button>
            
            <Button
              className="bg-[#E6FFF4] text-black hover:bg-[#E6FFF4]/90 flex-1"
              onClick={handleCheckIn}
            >
              <Camera className="w-4 h-4 mr-1" />
              Check In
            </Button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
};

export default VenueInfoDialog;
