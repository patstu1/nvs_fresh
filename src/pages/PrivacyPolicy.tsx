
import React from 'react';
import { ArrowLeft } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

const PrivacyPolicy: React.FC = () => {
  const navigate = useNavigate();
  
  return (
    <div className="min-h-screen bg-black text-[#E6FFF4] pb-20">
      {/* Header */}
      <div className="fixed top-0 left-0 right-0 bg-[#1A1A1A] z-10">
        <div className="flex items-center px-4 py-3">
          <button onClick={() => navigate(-1)} className="mr-3">
            <ArrowLeft className="w-6 h-6" />
          </button>
          <h1 className="text-xl font-semibold">Privacy Policy</h1>
        </div>
      </div>
      
      <div className="pt-16 px-4 max-w-3xl mx-auto">
        <div className="space-y-6">
          <section>
            <h2 className="text-xl font-semibold mb-3">Yo Bro Privacy Policy</h2>
            <p className="mb-2">Last Updated: April 15, 2025</p>
          </section>
          
          <section>
            <h3 className="text-lg font-medium mb-2">1. Information We Collect</h3>
            <p>We collect the following types of data:</p>
            <ul className="list-disc pl-6 space-y-1 text-[#E6FFF4]/80">
              <li>Account information (email, username, profile data)</li>
              <li>Device data (model, OS, version, IP address)</li>
              <li>User-generated content (photos, chat messages, posts, location if enabled)</li>
            </ul>
          </section>
          
          <section>
            <h3 className="text-lg font-medium mb-2">2. How We Use Your Information</h3>
            <p>We use your data to:</p>
            <ul className="list-disc pl-6 space-y-1 text-[#E6FFF4]/80">
              <li>Deliver app functionality</li>
              <li>Improve matchmaking and social features</li>
              <li>Personalize your experience across different sections</li>
              <li>Ensure community safety and enforce moderation</li>
            </ul>
          </section>
          
          <section>
            <h3 className="text-lg font-medium mb-2">3. User-Generated Content</h3>
            <p>
              Users may upload text and media. Content in certain sections (e.g., NOW) is blurred by default 
              until the user chooses to view it. You may report inappropriate content at any time.
            </p>
          </section>
          
          <section>
            <h3 className="text-lg font-medium mb-2">4. Data Sharing</h3>
            <p>We do not sell your personal data. Your information is only shared with third-party services 
              (e.g., Firebase, analytics providers) as required to run the app.</p>
          </section>
          
          <section>
            <h3 className="text-lg font-medium mb-2">5. Your Rights</h3>
            <p>
              You can request deletion of your data at any time by contacting support@yobroapp.com. 
              You may also deactivate your account in the app.
            </p>
          </section>
          
          <section>
            <h3 className="text-lg font-medium mb-2">6. Security</h3>
            <p>
              We use Firebase Authentication, encrypted storage, and moderation tools to protect 
              your data and interactions.
            </p>
          </section>
          
          <section>
            <h3 className="text-lg font-medium mb-2">7. Age Restriction</h3>
            <p>
              Yo Bro is only available to users 18 years or older. 
              Access to adult content is restricted behind an age-gated warning.
            </p>
          </section>
          
          <section>
            <h3 className="text-lg font-medium mb-2">8. Contact</h3>
            <p>
              If you have questions about this policy, contact us at: 
              <a 
                href="mailto:support@yobroapp.com" 
                className="text-[#C2FFE6] ml-2 hover:underline"
              >
                support@yobroapp.com
              </a>
            </p>
          </section>
        </div>
      </div>
    </div>
  );
};

export default PrivacyPolicy;
