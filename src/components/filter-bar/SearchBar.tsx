
import React from 'react';
import { Globe, Search } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';

interface SearchBarProps {
  searchQuery: string;
  setSearchQuery: (query: string) => void;
  onSubmit: (e: React.FormEvent) => void;
}

const SearchBar: React.FC<SearchBarProps> = ({
  searchQuery,
  setSearchQuery,
  onSubmit
}) => {
  return (
    <form onSubmit={onSubmit} className="w-full px-3">
      <div className="relative">
        <Input
          type="text"
          placeholder="Explore cities, venues, users..."
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          className="w-full pl-10 pr-4 py-2.5 text-sm bg-black border border-[#C2FFE6]/50 rounded-full text-[#C2FFE6] placeholder:text-[#C2FFE6]/50 focus:border-[#C2FFE6]/90 focus:ring-0 focus:outline-none"
          style={{ boxShadow: '0 0 5px rgba(194, 255, 230, 0.3)' }}
        />
        <div className="absolute left-4 top-2.5 w-4 h-4 flex items-center justify-center">
          <Globe className="w-4 h-4 text-[#C2FFE6] hover:text-[#C2FFE6]" style={{ transition: 'all 0.3s ease' }} />
        </div>
        <Button 
          type="submit" 
          size="sm" 
          variant="ghost" 
          className="absolute right-2 top-1.5 h-7 w-7 p-0 flex items-center justify-center"
        >
          <Search className="w-4 h-4 text-[#C2FFE6]/70 hover:text-[#C2FFE6]" style={{ transition: 'all 0.3s ease' }} />
        </Button>
      </div>
    </form>
  );
};

export default SearchBar;
