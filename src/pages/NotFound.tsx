
import React from 'react';
import { useLocation, useNavigate } from "react-router-dom";
import { useEffect } from "react";
import { Button } from '@/components/ui/button';
import { ArrowLeft, Home } from 'lucide-react';
import { useAuth } from '@/hooks/useAuth';

const NotFound = () => {
  const location = useLocation();
  const navigate = useNavigate();
  const { user } = useAuth();

  useEffect(() => {
    console.error(
      "404 Error: User attempted to access non-existent route:",
      location.pathname
    );
  }, [location.pathname]);

  const goBack = () => {
    navigate(-1);
  };

  const goHome = () => {
    navigate("/");
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-yobro-dark p-4">
      <div className="text-center p-6 bg-black rounded-lg border border-[#C2FFE6]/30 max-w-md w-full">
        <div className="mb-6">
          <div className="relative w-24 h-24 mx-auto bg-[#C2FFE6]/10 rounded-full flex items-center justify-center">
            <span className="text-4xl font-bold text-[#E6FFF4]">404</span>
            <div className="absolute inset-0 border-2 border-[#C2FFE6]/30 rounded-full animate-pulse"></div>
          </div>
        </div>
        
        <h1 className="text-2xl font-bold mb-2 text-[#E6FFF4]">Page not found</h1>
        <p className="text-md text-[#E6FFF4]/80 mb-8">
          We couldn't find the page you were looking for.
        </p>
        
        <div className="flex flex-col space-y-4 sm:flex-row sm:space-y-0 sm:space-x-4 justify-center">
          <Button 
            onClick={goBack}
            className="flex items-center justify-center gap-2 bg-[#C2FFE6] text-black hover:bg-[#C2FFE6]/90"
          >
            <ArrowLeft size={18} /> Go Back
          </Button>
          
          <Button 
            onClick={goHome}
            className="flex items-center justify-center gap-2 bg-black text-[#E6FFF4] border-2 border-[#E6FFF4] hover:bg-black/90"
          >
            <Home size={18} /> Home
          </Button>
        </div>
        
        {user && (
          <p className="mt-6 text-sm text-[#E6FFF4]/60">
            Logged in as {user.email}
          </p>
        )}
      </div>
    </div>
  );
};

export default NotFound;
