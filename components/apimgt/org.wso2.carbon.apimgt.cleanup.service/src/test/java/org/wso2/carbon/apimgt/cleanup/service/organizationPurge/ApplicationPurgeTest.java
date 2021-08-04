/*
 *  Copyright (c) 2017, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 *  WSO2 Inc. licenses this file to you under the Apache License,
 *  Version 2.0 (the "License"); you may not use this file except
 *  in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package org.wso2.carbon.apimgt.cleanup.service.organizationPurge;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.powermock.api.mockito.PowerMockito;
import org.powermock.core.classloader.annotations.PrepareForTest;
import org.powermock.modules.junit4.PowerMockRunner;
import org.wso2.carbon.apimgt.api.APIManagementException;
import org.wso2.carbon.apimgt.api.model.Application;
import org.wso2.carbon.apimgt.api.model.Subscriber;
import org.wso2.carbon.apimgt.impl.APIConstants;
import org.wso2.carbon.apimgt.impl.caching.CacheProvider;
import org.wso2.carbon.apimgt.impl.dao.ApiMgtDAO;
import org.mockito.Mockito;

import javax.cache.Cache;
import javax.cache.CacheManager;
import javax.cache.Caching;
import java.util.ArrayList;
import java.util.List;

@RunWith(PowerMockRunner.class)
@PrepareForTest({ Caching.class, Cache.class, CacheProvider.class, Cache.class })
public class ApplicationPurgeTest {

    private ApiMgtDAO apiMgtDAO;
    @Before
    public void init() {
        apiMgtDAO = Mockito.mock(ApiMgtDAO.class);
    }

    @Test
    public void testOrganizationRemoval() throws APIManagementException {

        Application application = Mockito.mock(Application.class);

        List<Application> applicationList = new ArrayList<>();
        applicationList.add(application);

        Mockito.doReturn(applicationList).when(apiMgtDAO).getApplicationsByOrganization("testOrg");
        Mockito.doNothing().when(apiMgtDAO).removePendingSubscriptions(Mockito.any());
        Mockito.doNothing().when(apiMgtDAO).removeApplicationCreationWorkflows(Mockito.any());
        Mockito.doNothing().when(apiMgtDAO).removeApplicationCreationWorkflows(Mockito.any());

        List<String> keyManagerViseKeyState = new ArrayList<>();
        keyManagerViseKeyState.add("org-removal-state-1");

        Mockito.doReturn(keyManagerViseKeyState).when(apiMgtDAO)
                .getPendingRegistrationsForApplicationList(Mockito.any(), Mockito.anyString());

        Mockito.doNothing().when(apiMgtDAO)
                .deleteApplicationRegistrationsWorkflowsForKeyManager(Mockito.any(), Mockito.any(), Mockito.any());

        List<Integer> subscriberIdList = new ArrayList<>();
        subscriberIdList.add(1);

        Mockito.doReturn(subscriberIdList).when(apiMgtDAO).getSubscribersForOrganization(Mockito.any());

        List<String> mappedOrganizations = new ArrayList<>();
        mappedOrganizations.add("testOrg");

        Mockito.doReturn(mappedOrganizations).when(apiMgtDAO).getMappedOrganizationListForSubscriber(Mockito.anyInt());
        Mockito.doNothing().when(apiMgtDAO).removeSubscriberOrganizationMapping(Mockito.anyInt(), Mockito.anyString());

        Subscriber subscriber = Mockito.mock(Subscriber.class);
        Mockito.doReturn(subscriber).when(apiMgtDAO).getSubscriber(Mockito.anyInt());
        Mockito.doNothing().when(apiMgtDAO).removeSubscriber(Mockito.anyInt());

        Cache cache = Mockito.mock(Cache.class);
        CacheManager cacheManager = Mockito.mock(CacheManager.class);
        PowerMockito.mockStatic(Caching.class);

        PowerMockito.when(Caching.getCacheManager(APIConstants.API_MANAGER_CACHE_MANAGER)).thenReturn(cacheManager);
        Mockito.when(cacheManager.getCache(Mockito.anyString())).thenReturn(cache);

        Subscriber cachedSubscriber = new Subscriber("application-purge-sub");

        PowerMockito.doReturn(cachedSubscriber).when(cache).get(Mockito.any());
        PowerMockito.doReturn(true).when(cache).remove(Mockito.any());
        Mockito.doNothing().when(apiMgtDAO).removeSubscriber(Mockito.anyInt());

        ApplicationPurge applicationPurge = new ApplicationPurgeWrapper(apiMgtDAO);
        applicationPurge.apiMgtDAO = apiMgtDAO;

        applicationPurge.deleteOrganization("testOrg");

        Mockito.verify(apiMgtDAO, Mockito.times(1)).getApplicationsByOrganization("testOrg");
        Mockito.verify(apiMgtDAO, Mockito.times(1)).removePendingSubscriptions(Mockito.any());
        Mockito.verify(apiMgtDAO, Mockito.times(1)).removeApplicationCreationWorkflows(Mockito.any());
        Mockito.verify(apiMgtDAO, Mockito.times(2))
                .getPendingRegistrationsForApplicationList(Mockito.any(), Mockito.anyString());
        Mockito.verify(apiMgtDAO, Mockito.times(2))
                .deleteApplicationRegistrationsWorkflowsForKeyManager(Mockito.any(), Mockito.any(),
                        Mockito.anyString());
        Mockito.verify(apiMgtDAO, Mockito.times(1)).deleteApplicationList(Mockito.any());
        Mockito.verify(apiMgtDAO, Mockito.times(1)).getSubscribersForOrganization(Mockito.any());
        Mockito.verify(apiMgtDAO, Mockito.times(1)).getMappedOrganizationListForSubscriber(Mockito.anyInt());
        Mockito.verify(apiMgtDAO, Mockito.times(1)).removeSubscriberOrganizationMapping(Mockito.anyInt(), Mockito.anyString());
        Mockito.verify(apiMgtDAO, Mockito.times(1)).getSubscriber(Mockito.anyInt());
        Mockito.verify(apiMgtDAO, Mockito.times(1)).removeSubscriber(Mockito.anyInt());

    }

    @Test
    public void testOrganizationRemovalShouldSkipRemovingSubscribers() throws APIManagementException {

        Application application = Mockito.mock(Application.class);

        List<Application> applicationList = new ArrayList<>();
        applicationList.add(application);

        Mockito.doReturn(applicationList).when(apiMgtDAO).getApplicationsByOrganization("testOrg");
        Mockito.doNothing().when(apiMgtDAO).removePendingSubscriptions(Mockito.any());
        Mockito.doNothing().when(apiMgtDAO).removeApplicationCreationWorkflows(Mockito.any());
        Mockito.doNothing().when(apiMgtDAO).removeApplicationCreationWorkflows(Mockito.any());

        List<String> keyManagerViseKeyState = new ArrayList<>();
        keyManagerViseKeyState.add("org-removal-state-1");

        Mockito.doReturn(keyManagerViseKeyState).when(apiMgtDAO)
                .getPendingRegistrationsForApplicationList(Mockito.any(), Mockito.anyString());

        Mockito.doNothing().when(apiMgtDAO)
                .deleteApplicationRegistrationsWorkflowsForKeyManager(Mockito.any(), Mockito.any(), Mockito.any());

        // no subscribers in subscriber list
        List<Integer> subscriberIdList = new ArrayList<>();

        Mockito.doReturn(subscriberIdList).when(apiMgtDAO).getSubscribersForOrganization(Mockito.any());

        List<String> mappedOrganizations = new ArrayList<>();
        mappedOrganizations.add("testOrg");

        Mockito.doReturn(mappedOrganizations).when(apiMgtDAO).getMappedOrganizationListForSubscriber(Mockito.anyInt());
        Mockito.doNothing().when(apiMgtDAO).removeSubscriberOrganizationMapping(Mockito.anyInt(), Mockito.anyString());

        Subscriber subscriber = Mockito.mock(Subscriber.class);
        Mockito.doReturn(subscriber).when(apiMgtDAO).getSubscriber(Mockito.anyInt());
        Mockito.doNothing().when(apiMgtDAO).removeSubscriber(Mockito.anyInt());

        Cache cache = Mockito.mock(Cache.class);
        CacheManager cacheManager = Mockito.mock(CacheManager.class);
        PowerMockito.mockStatic(Caching.class);

        PowerMockito.when(Caching.getCacheManager(APIConstants.API_MANAGER_CACHE_MANAGER)).thenReturn(cacheManager);
        Mockito.when(cacheManager.getCache(Mockito.anyString())).thenReturn(cache);

        Subscriber cachedSubscriber = new Subscriber("application-purge-sub");

        PowerMockito.doReturn(cachedSubscriber).when(cache).get(Mockito.any());
        PowerMockito.doReturn(true).when(cache).remove(Mockito.any());
        Mockito.doNothing().when(apiMgtDAO).removeSubscriber(Mockito.anyInt());

        ApplicationPurge applicationPurge = new ApplicationPurgeWrapper(apiMgtDAO);
        applicationPurge.apiMgtDAO = apiMgtDAO;

        applicationPurge.deleteOrganization("testOrg");

        Mockito.verify(apiMgtDAO, Mockito.times(1)).getApplicationsByOrganization("testOrg");
        Mockito.verify(apiMgtDAO, Mockito.times(1)).removePendingSubscriptions(Mockito.any());
        Mockito.verify(apiMgtDAO, Mockito.times(1)).removeApplicationCreationWorkflows(Mockito.any());
        Mockito.verify(apiMgtDAO, Mockito.times(2))
                .getPendingRegistrationsForApplicationList(Mockito.any(), Mockito.anyString());
        Mockito.verify(apiMgtDAO, Mockito.times(2))
                .deleteApplicationRegistrationsWorkflowsForKeyManager(Mockito.any(), Mockito.any(),
                        Mockito.anyString());
        Mockito.verify(apiMgtDAO, Mockito.times(1)).deleteApplicationList(Mockito.any());
        Mockito.verify(apiMgtDAO, Mockito.times(1)).getSubscribersForOrganization(Mockito.any());

        Mockito.verify(apiMgtDAO, Mockito.never()).getMappedOrganizationListForSubscriber(Mockito.anyInt());
        Mockito.verify(apiMgtDAO, Mockito.never()).removeSubscriberOrganizationMapping(Mockito.anyInt(), Mockito.anyString());
        Mockito.verify(apiMgtDAO, Mockito.never()).getSubscriber(Mockito.anyInt());
        Mockito.verify(apiMgtDAO, Mockito.never()).removeSubscriber(Mockito.anyInt());

    }

    @Test
    public void testOrganizationRemovalShouldSkipSubscriberDeletion() throws APIManagementException {

        Application application = Mockito.mock(Application.class);

        List<Application> applicationList = new ArrayList<>();
        applicationList.add(application);

        Mockito.doReturn(applicationList).when(apiMgtDAO).getApplicationsByOrganization("testOrg");
        Mockito.doNothing().when(apiMgtDAO).removePendingSubscriptions(Mockito.any());
        Mockito.doNothing().when(apiMgtDAO).removeApplicationCreationWorkflows(Mockito.any());
        Mockito.doNothing().when(apiMgtDAO).removeApplicationCreationWorkflows(Mockito.any());

        List<String> keyManagerViseKeyState = new ArrayList<>();
        keyManagerViseKeyState.add("org-removal-state-1");

        Mockito.doReturn(keyManagerViseKeyState).when(apiMgtDAO)
                .getPendingRegistrationsForApplicationList(Mockito.any(), Mockito.anyString());

        Mockito.doNothing().when(apiMgtDAO)
                .deleteApplicationRegistrationsWorkflowsForKeyManager(Mockito.any(), Mockito.any(), Mockito.any());

        List<Integer> subscriberIdList = new ArrayList<>();
        subscriberIdList.add(2);

        Mockito.doReturn(subscriberIdList).when(apiMgtDAO).getSubscribersForOrganization(Mockito.any());

        // more than one entry is present on mapped subscriber array
        List<String> mappedOrganizations = new ArrayList<>();
        mappedOrganizations.add("testOrg");
        mappedOrganizations.add("testOrg2");

        Mockito.doReturn(mappedOrganizations).when(apiMgtDAO).getMappedOrganizationListForSubscriber(Mockito.anyInt());
        Mockito.doNothing().when(apiMgtDAO).removeSubscriberOrganizationMapping(Mockito.anyInt(), Mockito.anyString());

        Subscriber subscriber = Mockito.mock(Subscriber.class);
        Mockito.doReturn(subscriber).when(apiMgtDAO).getSubscriber(Mockito.anyInt());
        Mockito.doNothing().when(apiMgtDAO).removeSubscriber(Mockito.anyInt());

        Cache cache = Mockito.mock(Cache.class);
        CacheManager cacheManager = Mockito.mock(CacheManager.class);
        PowerMockito.mockStatic(Caching.class);

        PowerMockito.when(Caching.getCacheManager(APIConstants.API_MANAGER_CACHE_MANAGER)).thenReturn(cacheManager);
        Mockito.when(cacheManager.getCache(Mockito.anyString())).thenReturn(cache);

        Subscriber cachedSubscriber = new Subscriber("application-purge-sub");

        PowerMockito.doReturn(cachedSubscriber).when(cache).get(Mockito.any());
        PowerMockito.doReturn(true).when(cache).remove(Mockito.any());
        Mockito.doNothing().when(apiMgtDAO).removeSubscriber(Mockito.anyInt());

        ApplicationPurge applicationPurge = new ApplicationPurgeWrapper(apiMgtDAO);
        applicationPurge.apiMgtDAO = apiMgtDAO;

        applicationPurge.deleteOrganization("testOrg");

        Mockito.verify(apiMgtDAO, Mockito.times(1)).getApplicationsByOrganization("testOrg");
        Mockito.verify(apiMgtDAO, Mockito.times(1)).removePendingSubscriptions(Mockito.any());
        Mockito.verify(apiMgtDAO, Mockito.times(1)).removeApplicationCreationWorkflows(Mockito.any());
        Mockito.verify(apiMgtDAO, Mockito.times(2))
                .getPendingRegistrationsForApplicationList(Mockito.any(), Mockito.anyString());
        Mockito.verify(apiMgtDAO, Mockito.times(2))
                .deleteApplicationRegistrationsWorkflowsForKeyManager(Mockito.any(), Mockito.any(),
                        Mockito.anyString());
        Mockito.verify(apiMgtDAO, Mockito.times(1)).deleteApplicationList(Mockito.any());
        Mockito.verify(apiMgtDAO, Mockito.times(1)).getSubscribersForOrganization(Mockito.any());

        Mockito.verify(apiMgtDAO, Mockito.times(1)).getMappedOrganizationListForSubscriber(Mockito.anyInt());
        Mockito.verify(apiMgtDAO, Mockito.times(1)).removeSubscriberOrganizationMapping(Mockito.anyInt(), Mockito.anyString());

        Mockito.verify(apiMgtDAO, Mockito.never()).getSubscriber(Mockito.anyInt());
        Mockito.verify(apiMgtDAO, Mockito.never()).removeSubscriber(Mockito.anyInt());

    }

}
