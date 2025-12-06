
import React from 'react';
import { ArrowLeft, Rocket, CheckCircle, AlertCircle, Globe, Smartphone, FileText, Send } from 'lucide-react';
import { useNavigate, Link } from 'react-router-dom';
import DeploymentReadyCheck from '@/components/DeploymentReadyCheck';
import { Button } from '@/components/ui/button';

const DeploymentReady: React.FC = () => {
  const navigate = useNavigate();
  
  const openTestFlightNotes = () => {
    const reviewNotes = `App Description for Review:
Yo Bro is a gay male social and dating app featuring four distinct discovery modes:
	•	GRID (public profile discovery)
	•	NOW (anonymous, map-based browsing)
	•	LIVE (real-time proximity chatroom)
	•	CONNECT (AI-based matchmaking)

The app includes user-generated profiles, chat, and media uploads.
All content in the NOW section is blurred by default and only becomes visible through user-initiated interaction (tap-to-unlock).
We include moderation tools such as "Report Profile" and "Blur This Again" for safety and compliance.

No explicit content is displayed on app launch or without user action. Age gate is presented before entering the NOW section.

Login Requirements:
You can sign in using a dummy test account or create a new one. No invite code is needed.`;

    navigator.clipboard.writeText(reviewNotes);
    alert('TestFlight Review Notes copied to clipboard!');
  };

  return (
    <div className="min-h-screen bg-black text-[#E6FFF4] pb-20">
      {/* Header */}
      <div className="fixed top-0 left-0 right-0 bg-[#1A1A1A] z-10">
        <div className="flex items-center px-4 py-3">
          <button onClick={() => navigate(-1)} className="mr-3">
            <ArrowLeft className="w-6 h-6" />
          </button>
          <h1 className="text-xl font-semibold">Deployment Ready</h1>
        </div>
      </div>
      
      <div className="pt-16 px-4">
        <div className="flex flex-col items-center text-center mb-8">
          <div className="w-20 h-20 bg-[#2A2A2A] rounded-full flex items-center justify-center mb-4">
            <Rocket className="w-10 h-10 text-[#E6FFF4]" />
          </div>
          <h2 className="text-2xl font-bold mb-2">Launch Checklist</h2>
          <p className="text-[#E6FFF4]/70">
            Review deployment readiness and ensure all requirements are met before launching your app.
          </p>
        </div>
        
        {/* Deployment checks */}
        <DeploymentReadyCheck />
        
        {/* TestFlight and Review Notes */}
        <div className="bg-[#1A1A1A] rounded-lg border border-[#E6FFF4]/20 p-5 mb-6">
          <h3 className="font-semibold text-[#E6FFF4] mb-3">TestFlight Preparation</h3>
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <div className="flex items-center">
                <Send className="w-5 h-5 text-[#E6FFF4] mr-2" />
                <span>TestFlight Review Notes</span>
              </div>
              <Button 
                variant="ghost"
                size="sm"
                onClick={openTestFlightNotes}
                className="text-[#E6FFF4]/70 hover:text-[#E6FFF4]"
              >
                Copy Notes
              </Button>
            </div>
            <div className="flex justify-between items-center">
              <div className="flex items-center">
                <Smartphone className="w-5 h-5 text-[#E6FFF4] mr-2" />
                <span>TestFlight Guide</span>
              </div>
              <Button 
                variant="ghost"
                size="sm"
                className="text-[#E6FFF4]/70 hover:text-[#E6FFF4]"
                asChild
              >
                <Link to="/testflight">View</Link>
              </Button>
            </div>
          </div>
        </div>
        
        {/* Privacy Policy */}
        <div className="bg-[#1A1A1A] rounded-lg border border-[#E6FFF4]/20 p-5 mb-6">
          <h3 className="font-semibold text-[#E6FFF4] mb-3">Legal Requirements</h3>
          <div className="space-y-3">
            <div className="flex justify-between items-center">
              <div className="flex items-center">
                <FileText className="w-5 h-5 text-green-400 mr-2" />
                <span>Privacy Policy</span>
              </div>
              <Button 
                variant="ghost"
                size="sm"
                className="text-[#E6FFF4]/70 hover:text-[#E6FFF4]"
                asChild
              >
                <Link to="/privacy-policy">View</Link>
              </Button>
            </div>
          </div>
        </div>
        
        {/* Performance recommendations */}
        <div className="bg-[#1A1A1A] rounded-lg border border-[#E6FFF4]/20 p-5 mb-6">
          <h3 className="font-semibold text-[#E6FFF4] mb-3">Performance Optimization</h3>
          <div className="space-y-2">
            <div className="flex items-center">
              <CheckCircle className="w-5 h-5 text-green-400 mr-2 flex-shrink-0" />
              <span className="text-sm">Image optimization complete for faster loading</span>
            </div>
            <div className="flex items-center">
              <CheckCircle className="w-5 h-5 text-green-400 mr-2 flex-shrink-0" />
              <span className="text-sm">Component lazy-loading implemented for initial fast load</span>
            </div>
            <div className="flex items-center">
              <AlertCircle className="w-5 h-5 text-yellow-400 mr-2 flex-shrink-0" />
              <span className="text-sm">Consider implementing analytics for user behavior tracking</span>
            </div>
          </div>
        </div>
        
        {/* Next steps */}
        <div className="bg-[#1A1A1A] rounded-lg border border-[#E6FFF4]/20 p-5">
          <h3 className="font-semibold text-[#E6FFF4] mb-3">Next Steps</h3>
          <ol className="list-decimal pl-5 space-y-2 text-sm">
            <li>Complete all checks marked with warnings</li>
            <li>Prepare app screenshots for app store listings</li>
            <li>Create compelling app description and metadata</li>
            <li>Set up analytics to track user engagement</li>
            <li>Prepare marketing materials for app launch</li>
          </ol>
          
          <div className="mt-5 pt-5 border-t border-[#E6FFF4]/10">
            <Button className="w-full bg-[#E6FFF4] text-black hover:bg-white">
              <Globe className="w-4 h-4 mr-2" />
              Prepare for Deployment
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default DeploymentReady;
