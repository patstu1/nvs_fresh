
import { useState, useEffect } from 'react';
import { User } from '../types/markerTypes';

interface Cluster {
  id: string;
  count: number;
  coordinates: [number, number];
  points: User[];
}

export const useClusterUsers = (nearbyUsers: User[]) => {
  const [clusters, setClusters] = useState<Cluster[]>([]);
  
  useEffect(() => {
    if (nearbyUsers.length > 0) {
      const maxDistance = 0.01;
      const userGroups: {[key: string]: User[]} = {};
      
      nearbyUsers.forEach(user => {
        let foundCluster = false;
        
        Object.keys(userGroups).forEach(groupId => {
          const group = userGroups[groupId];
          const firstUser = group[0];
          
          const distance = Math.sqrt(
            Math.pow(user.position.lat - firstUser.position.lat, 2) +
            Math.pow(user.position.lng - firstUser.position.lng, 2)
          );
          
          if (distance < maxDistance) {
            userGroups[groupId].push(user);
            foundCluster = true;
          }
        });
        
        if (!foundCluster) {
          const newGroupId = `cluster-${user.id}`;
          userGroups[newGroupId] = [user];
        }
      });
      
      const newClusters = Object.keys(userGroups).map(groupId => {
        const group = userGroups[groupId];
        
        if (group.length >= 3) {
          const avgLat = group.reduce((sum, user) => sum + user.position.lat, 0) / group.length;
          const avgLng = group.reduce((sum, user) => sum + user.position.lng, 0) / group.length;
          
          return {
            id: groupId,
            count: group.length,
            coordinates: [avgLng, avgLat] as [number, number],
            points: group
          };
        }
        return null;
      }).filter(cluster => cluster !== null) as Cluster[];
      
      setClusters(newClusters);
    }
  }, [nearbyUsers]);
  
  return { clusters };
};
