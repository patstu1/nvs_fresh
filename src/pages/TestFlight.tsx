
import React from 'react';
import { ArrowLeft, CheckCircle } from 'lucide-react';
import { useNavigate } from 'react-router-dom';

const TestFlight: React.FC = () => {
  const navigate = useNavigate();
  
  return (
    <div className="min-h-screen bg-black text-[#E6FFF4] pb-20">
      {/* Header */}
      <div className="fixed top-0 left-0 right-0 bg-[#1A1A1A] z-10">
        <div className="flex items-center px-4 py-3">
          <button onClick={() => navigate(-1)} className="mr-3">
            <ArrowLeft className="w-6 h-6" />
          </button>
          <h1 className="text-xl font-semibold">TestFlight Preparation</h1>
        </div>
      </div>
      
      <div className="pt-16 px-4 max-w-3xl mx-auto">
        <div className="space-y-6">
          <section>
            <h2 className="text-xl font-semibold mb-3">TestFlight Preparation Guide</h2>
            <p className="mb-4">
              Follow these steps to create an IPA file and upload it to TestFlight for testing.
            </p>
          </section>
          
          <div className="bg-[#1A1A1A] rounded-lg border border-[#E6FFF4]/20 p-5 mb-6">
            <h3 className="font-semibold text-[#E6FFF4] mb-3">Step-by-Step Guide</h3>
            
            <ol className="space-y-4">
              <li className="flex">
                <div className="mr-3 mt-1">
                  <CheckCircle className="w-5 h-5 text-green-400" />
                </div>
                <div>
                  <h4 className="font-medium">Clone the project locally</h4>
                  <p className="text-sm text-[#E6FFF4]/70 mt-1">
                    Use Git to clone the project to your local machine.
                  </p>
                </div>
              </li>
              
              <li className="flex">
                <div className="mr-3 mt-1">
                  <CheckCircle className="w-5 h-5 text-green-400" />
                </div>
                <div>
                  <h4 className="font-medium">Install dependencies</h4>
                  <p className="text-sm text-[#E6FFF4]/70 mt-1">
                    Run <code className="bg-[#2A2A2A] px-1 py-0.5 rounded">npm install</code> to install all required packages.
                  </p>
                </div>
              </li>
              
              <li className="flex">
                <div className="mr-3 mt-1">
                  <CheckCircle className="w-5 h-5 text-green-400" />
                </div>
                <div>
                  <h4 className="font-medium">Add iOS platform</h4>
                  <p className="text-sm text-[#E6FFF4]/70 mt-1">
                    Run <code className="bg-[#2A2A2A] px-1 py-0.5 rounded">npx cap add ios</code> to add the iOS platform.
                  </p>
                </div>
              </li>
              
              <li className="flex">
                <div className="mr-3 mt-1">
                  <CheckCircle className="w-5 h-5 text-green-400" />
                </div>
                <div>
                  <h4 className="font-medium">Build the project</h4>
                  <p className="text-sm text-[#E6FFF4]/70 mt-1">
                    Run <code className="bg-[#2A2A2A] px-1 py-0.5 rounded">npm run build</code> to create a production build.
                  </p>
                </div>
              </li>
              
              <li className="flex">
                <div className="mr-3 mt-1">
                  <CheckCircle className="w-5 h-5 text-green-400" />
                </div>
                <div>
                  <h4 className="font-medium">Sync Capacitor</h4>
                  <p className="text-sm text-[#E6FFF4]/70 mt-1">
                    Run <code className="bg-[#2A2A2A] px-1 py-0.5 rounded">npx cap sync ios</code> to sync the web build with the iOS project.
                  </p>
                </div>
              </li>
              
              <li className="flex">
                <div className="mr-3 mt-1">
                  <CheckCircle className="w-5 h-5 text-green-400" />
                </div>
                <div>
                  <h4 className="font-medium">Open Xcode</h4>
                  <p className="text-sm text-[#E6FFF4]/70 mt-1">
                    Run <code className="bg-[#2A2A2A] px-1 py-0.5 rounded">npx cap open ios</code> to open the iOS project in Xcode.
                  </p>
                </div>
              </li>
              
              <li className="flex">
                <div className="mr-3 mt-1">
                  <CheckCircle className="w-5 h-5 text-green-400" />
                </div>
                <div>
                  <h4 className="font-medium">Configure signing in Xcode</h4>
                  <p className="text-sm text-[#E6FFF4]/70 mt-1">
                    In Xcode, select your target and go to "Signing & Capabilities" to select your team and configure app signing.
                  </p>
                </div>
              </li>
              
              <li className="flex">
                <div className="mr-3 mt-1">
                  <CheckCircle className="w-5 h-5 text-green-400" />
                </div>
                <div>
                  <h4 className="font-medium">Create archive</h4>
                  <p className="text-sm text-[#E6FFF4]/70 mt-1">
                    In Xcode, select "Product &gt; Archive" to create an archive of your app.
                  </p>
                </div>
              </li>
              
              <li className="flex">
                <div className="mr-3 mt-1">
                  <CheckCircle className="w-5 h-5 text-green-400" />
                </div>
                <div>
                  <h4 className="font-medium">Upload to TestFlight</h4>
                  <p className="text-sm text-[#E6FFF4]/70 mt-1">
                    In the Organizer window that appears after archiving, click "Distribute App" and follow the steps to upload to App Store Connect for TestFlight testing.
                  </p>
                </div>
              </li>
              
              <li className="flex">
                <div className="mr-3 mt-1">
                  <CheckCircle className="w-5 h-5 text-green-400" />
                </div>
                <div>
                  <h4 className="font-medium">Wait for processing</h4>
                  <p className="text-sm text-[#E6FFF4]/70 mt-1">
                    Once uploaded, your build will be processed by Apple. This can take a few minutes to hours.
                  </p>
                </div>
              </li>
              
              <li className="flex">
                <div className="mr-3 mt-1">
                  <CheckCircle className="w-5 h-5 text-green-400" />
                </div>
                <div>
                  <h4 className="font-medium">Invite testers</h4>
                  <p className="text-sm text-[#E6FFF4]/70 mt-1">
                    After processing, invite testers via App Store Connect to try your TestFlight build.
                  </p>
                </div>
              </li>
            </ol>
          </div>
          
          <div className="bg-[#1A1A1A] rounded-lg border border-[#E6FFF4]/20 p-5">
            <h3 className="font-semibold text-[#E6FFF4] mb-3">Requirements</h3>
            <ul className="space-y-2 text-sm text-[#E6FFF4]/80">
              <li>- macOS computer with Xcode 14 or later</li>
              <li>- Apple Developer account ($99/year)</li>
              <li>- Valid provisioning profile and certificates</li>
              <li>- App Icon assets (1024x1024 and various sizes)</li>
              <li>- App Store screenshots prepared</li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  );
};

export default TestFlight;
