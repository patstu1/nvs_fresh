
import React, { useState, useEffect } from 'react';
import { sampleSearchProfiles, searchProfiles } from '@/services/searchService';
import SearchForm from './search/SearchForm';
import SearchResults from './search/SearchResults';
import PopularSearches from './search/PopularSearches';
import { useToast } from '@/hooks/use-toast';

interface SearchViewProps {
  onProfileClick: (id: string) => void;
}

const SearchView: React.FC<SearchViewProps> = ({ onProfileClick }) => {
  const [searchQuery, setSearchQuery] = useState('');
  const [searchResults, setSearchResults] = useState<typeof sampleSearchProfiles>([]);
  const [isSearching, setIsSearching] = useState(false);
  const [searchType, setSearchType] = useState<'all' | 'profiles' | 'tags' | 'cities'>('all');
  const [searchHistory, setSearchHistory] = useState<string[]>([]);
  const { toast } = useToast();
  
  // Handle search history from localStorage
  useEffect(() => {
    const storedHistory = localStorage.getItem('searchHistory');
    if (storedHistory) {
      setSearchHistory(JSON.parse(storedHistory));
    }
    
    const handleStorageChange = (event: StorageEvent) => {
      if (event.key === 'searchHistory') {
        const updatedHistory = event.newValue ? JSON.parse(event.newValue) : [];
        setSearchHistory(updatedHistory);
      }
    };
    
    window.addEventListener('storage', handleStorageChange);
    return () => {
      window.removeEventListener('storage', handleStorageChange);
    };
  }, []);
  
  // Save search query to history
  const saveToSearchHistory = (query: string) => {
    if (!query.trim() || searchHistory.includes(query)) return;
    
    const updatedHistory = [query, ...searchHistory.slice(0, 9)];
    setSearchHistory(updatedHistory);
    localStorage.setItem('searchHistory', JSON.stringify(updatedHistory));
  };
  
  const handleSearch = (e: React.FormEvent) => {
    e.preventDefault();
    if (!searchQuery.trim()) return;
    
    // Save search to history
    saveToSearchHistory(searchQuery);
    
    setIsSearching(true);
    // Simulate loading state
    setTimeout(() => {
      const results = searchProfiles(sampleSearchProfiles, searchQuery, searchType);
      setSearchResults(results);
      
      if (results.length === 0) {
        toast({
          title: "No matches found",
          description: `No ${searchType === 'all' ? 'results' : searchType} found for "${searchQuery}"`,
        });
      } else {
        toast({
          title: "Search Complete",
          description: `Found ${results.length} ${searchType === 'profiles' ? 'profiles' : 'results'}`,
        });
      }
    }, 500);
  };
  
  const clearSearch = () => {
    setSearchQuery('');
    setSearchResults([]);
    setIsSearching(false);
  };
  
  const clearSearchHistory = () => {
    setSearchHistory([]);
    localStorage.removeItem('searchHistory');
    toast({
      title: "Search history cleared",
      description: "Your search history has been deleted",
    });
  };
  
  const handleTagClick = (tag: string, type: 'all' | 'profiles' | 'tags' | 'cities') => {
    setSearchQuery(tag);
    setSearchType(type);
    
    // Simulate a search action
    setIsSearching(true);
    setTimeout(() => {
      const results = searchProfiles(sampleSearchProfiles, tag, type);
      setSearchResults(results);
      
      // Save to history
      saveToSearchHistory(tag);
      
      toast({
        title: "Search Complete",
        description: `Found ${results.length} matches for "${tag}"`,
      });
    }, 300);
  };

  return (
    <div className="w-full h-full pt-16 pb-20 px-4 bg-black">
      <SearchForm 
        searchQuery={searchQuery}
        setSearchQuery={setSearchQuery}
        searchType={searchType}
        setSearchType={setSearchType}
        handleSearch={handleSearch}
        clearSearch={clearSearch}
        searchHistory={searchHistory}
        clearSearchHistory={clearSearchHistory}
      />
      
      {isSearching ? (
        <SearchResults 
          searchResults={searchResults}
          onProfileClick={onProfileClick}
          clearSearch={clearSearch}
          searchType={searchType}
        />
      ) : (
        <PopularSearches onTagClick={handleTagClick} />
      )}
    </div>
  );
};

export default SearchView;
