
import React, { useState } from 'react';
import { Button } from '@/components/ui/button';
import { Card, CardContent } from '@/components/ui/card';
import { Separator } from '@/components/ui/separator';
import { Heart, MessageSquare, Share, Star, Shield, User } from 'lucide-react';

const ProfileView = () => {
  const [activeTab, setActiveTab] = useState('about');
  
  return (
    <div className="flex flex-col h-full bg-luxury-snakeskin-dark">
      {/* Header with profile image */}
      <div className="relative h-72">
        <div 
          className="absolute inset-0 bg-cover bg-center" 
          style={{ backgroundImage: "url(https://images.unsplash.com/photo-1615529328331-f8917597711f?q=80&w=800&auto=format&fit=crop)" }}
        >
          <div className="absolute inset-0 bg-gradient-to-t from-luxury-snakeskin-dark via-transparent to-transparent" />
        </div>
        
        <div className="absolute bottom-0 w-full p-6 flex items-end">
          <div className="relative">
            <div className="w-24 h-24 rounded-full overflow-hidden border-2 border-luxury-pink/30 crystal-shimmer">
              <img 
                src="https://images.unsplash.com/photo-1664575602276-acd073f104c1?q=80&w=200&auto=format&fit=crop" 
                alt="Profile" 
                className="w-full h-full object-cover" 
              />
            </div>
            <div className="absolute bottom-0 right-0 w-8 h-8 bg-luxury-olive-medium/90 rounded-full flex items-center justify-center border-2 border-luxury-snakeskin-dark">
              <Shield className="w-4 h-4 text-luxury-crystal" />
            </div>
          </div>
          
          <div className="ml-4 flex-1">
            <h1 className="text-2xl font-bold text-luxury-crystal mb-1">Alessandra</h1>
            <div className="flex items-center text-sm text-luxury-crystal/80">
              <span className="flex items-center">
                <User className="w-3 h-3 mr-1" />
                28
              </span>
              <span className="mx-2">•</span>
              <span>2 mi away</span>
            </div>
          </div>
        </div>
      </div>
      
      {/* Action buttons */}
      <div className="px-6 py-4 flex justify-between">
        <Button variant="fur" size="icon" className="rounded-full w-12 h-12">
          <Star className="w-5 h-5" />
        </Button>
        
        <Button variant="olive" size="icon" className="rounded-full w-12 h-12">
          <Heart className="w-5 h-5" />
        </Button>
        
        <Button variant="snakeskin" size="icon" className="rounded-full w-12 h-12">
          <MessageSquare className="w-5 h-5" />
        </Button>
        
        <Button variant="chandelier" size="icon" className="rounded-full w-12 h-12">
          <Share className="w-5 h-5" />
        </Button>
      </div>
      
      <Separator className="luxury-divider my-2" />
      
      {/* Tabs */}
      <div className="px-6 flex space-x-2 mb-4">
        <Button 
          variant={activeTab === 'about' ? 'ring-active' : 'ring'}
          onClick={() => setActiveTab('about')}
          className="flex-1"
        >
          About
        </Button>
        <Button 
          variant={activeTab === 'photos' ? 'ring-active' : 'ring'} 
          onClick={() => setActiveTab('photos')}
          className="flex-1"
        >
          Photos
        </Button>
        <Button 
          variant={activeTab === 'interests' ? 'ring-active' : 'ring'} 
          onClick={() => setActiveTab('interests')}
          className="flex-1"
        >
          Interests
        </Button>
      </div>
      
      {/* Content */}
      <div className="flex-1 px-6 pb-6 overflow-y-auto scrollbar-thin">
        {activeTab === 'about' && (
          <div className="space-y-6">
            <Card className="luxury-card overflow-hidden">
              <CardContent className="p-5">
                <h3 className="text-lg mb-3 luxury-gold-text">About Me</h3>
                <p className="text-luxury-crystal/80">
                  Luxury lifestyle enthusiast with a passion for design, art, and travel. I appreciate the finer things in life 
                  and enjoy meaningful connections with like-minded individuals.
                </p>
              </CardContent>
            </Card>
            
            <Card className="luxury-card overflow-hidden">
              <CardContent className="p-5">
                <h3 className="text-lg mb-3 luxury-gold-text">My Basics</h3>
                <div className="grid grid-cols-2 gap-4">
                  <div className="user-metric p-3 rounded-lg">
                    <p className="text-sm text-luxury-crystal/70">Education</p>
                    <p className="text-luxury-crystal">Design Institute</p>
                  </div>
                  <div className="user-metric p-3 rounded-lg">
                    <p className="text-sm text-luxury-crystal/70">Occupation</p>
                    <p className="text-luxury-crystal">Interior Designer</p>
                  </div>
                  <div className="user-metric p-3 rounded-lg">
                    <p className="text-sm text-luxury-crystal/70">Height</p>
                    <p className="text-luxury-crystal">5'8"</p>
                  </div>
                  <div className="user-metric p-3 rounded-lg">
                    <p className="text-sm text-luxury-crystal/70">Languages</p>
                    <p className="text-luxury-crystal">English, Italian</p>
                  </div>
                </div>
              </CardContent>
            </Card>
            
            <Card className="luxury-card overflow-hidden">
              <CardContent className="p-5">
                <h3 className="text-lg mb-3 luxury-gold-text">Lifestyle</h3>
                <div className="grid grid-cols-2 gap-4">
                  <div className="user-metric p-3 rounded-lg">
                    <p className="text-sm text-luxury-crystal/70">Drinks</p>
                    <p className="text-luxury-crystal">Social drinker</p>
                  </div>
                  <div className="user-metric p-3 rounded-lg">
                    <p className="text-sm text-luxury-crystal/70">Pets</p>
                    <p className="text-luxury-crystal">Cat lover</p>
                  </div>
                  <div className="user-metric p-3 rounded-lg">
                    <p className="text-sm text-luxury-crystal/70">Workout</p>
                    <p className="text-luxury-crystal">Pilates, Yoga</p>
                  </div>
                  <div className="user-metric p-3 rounded-lg">
                    <p className="text-sm text-luxury-crystal/70">Star Sign</p>
                    <p className="text-luxury-crystal">Leo</p>
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        )}
        
        {activeTab === 'photos' && (
          <div className="grid grid-cols-2 gap-3">
            {[1, 2, 3, 4, 5, 6].map((i) => (
              <div key={i} className="aspect-square rounded-lg overflow-hidden crystal-shimmer">
                <img 
                  src={`https://images.unsplash.com/photo-151${i + 5000000}?q=80&w=400&auto=format&fit=crop`} 
                  alt={`Gallery photo ${i}`} 
                  className="w-full h-full object-cover" 
                />
              </div>
            ))}
          </div>
        )}
        
        {activeTab === 'interests' && (
          <div className="grid grid-cols-2 gap-3">
            {['Art', 'Design', 'Travel', 'Fine Dining', 'Fashion', 'Museums', 'Hiking', 'Photography'].map((interest) => (
              <div key={interest} className="olive-bg p-3 rounded-lg">
                <p className="text-luxury-crystal">{interest}</p>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
};

export default ProfileView;
