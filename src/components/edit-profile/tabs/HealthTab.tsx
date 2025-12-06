
import React from 'react';
import { Input } from "@/components/ui/input";
import { Switch } from "@/components/ui/switch";
import { Label } from "@/components/ui/label";

interface HealthTabProps {
  healthInfo: {
    hivStatus: string;
    lastTestedDate: string;
    testingReminders: boolean;
    vaccinations: string[];
  };
  setHealthInfo: (info: any) => void;
}

const HealthTab: React.FC<HealthTabProps> = ({
  healthInfo,
  setHealthInfo
}) => {
  return (
    <div className="p-4">
      <div className="space-y-6">
        <div>
          <label className="block text-sm font-medium mb-2">HIV Status</label>
          <select
            value={healthInfo.hivStatus}
            onChange={(e) => setHealthInfo({...healthInfo, hivStatus: e.target.value})}
            className="w-full bg-[#222] rounded-md p-3 text-white"
          >
            <option value="Negative, on PrEP">Negative, on PrEP</option>
            <option value="Negative">Negative</option>
            <option value="Positive, Undetectable">Positive, Undetectable</option>
            <option value="Positive">Positive</option>
            <option value="Unknown">Unknown</option>
          </select>
        </div>
        
        <div>
          <label className="block text-sm font-medium mb-2">Last Tested Date</label>
          <Input
            type="month"
            value={healthInfo.lastTestedDate}
            onChange={(e) => setHealthInfo({...healthInfo, lastTestedDate: e.target.value})}
            className="bg-[#222]"
          />
        </div>
        
        <div className="flex items-center justify-between">
          <Label htmlFor="testing-reminders">Testing Reminders</Label>
          <Switch
            id="testing-reminders"
            checked={healthInfo.testingReminders}
            onCheckedChange={(checked) => 
              setHealthInfo({...healthInfo, testingReminders: checked})
            }
          />
        </div>
        
        <div>
          <label className="block text-sm font-medium mb-2">Vaccinations</label>
          <div className="space-y-2">
            {["COVID-19", "Monkeypox", "Meningitis", "Hepatitis"].map((vaccine) => (
              <div key={vaccine} className="flex items-center">
                <input
                  type="checkbox"
                  id={vaccine}
                  checked={healthInfo.vaccinations.includes(vaccine)}
                  onChange={(e) => {
                    const newVaccinations = e.target.checked
                      ? [...healthInfo.vaccinations, vaccine]
                      : healthInfo.vaccinations.filter((v: string) => v !== vaccine);
                    setHealthInfo({...healthInfo, vaccinations: newVaccinations});
                  }}
                  className="mr-2"
                />
                <label htmlFor={vaccine}>{vaccine}</label>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default HealthTab;
