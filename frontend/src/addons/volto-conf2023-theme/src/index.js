import CountdownEdit from './components/Blocks/Countdown/Edit';
import CountdownView from './components/Blocks/Countdown/View';
import CTAEdit from './components/Blocks/CTA/Edit';
import CTAView from './components/Blocks/CTA/View';
import FixedBackgroundEdit from './components/Blocks/FixedBackground/Edit';
import FixedBackgroundView from './components/Blocks/FixedBackground/View';
import HeroImageEdit from './components/Blocks/HeroImage/Edit';
import HeroImageView from './components/Blocks/HeroImage/View';
import NucliaEdit from './components/Blocks/Nuclia/Edit';
import NucliaView from './components/Blocks/Nuclia/View';
import PayPalEdit from './components/Blocks/PayPal/Edit';
import PayPalView from './components/Blocks/PayPal/View';
import ScheduleEdit from './components/Blocks/Schedule/Edit';
import ScheduleView from './components/Blocks/Schedule/View';
import SponsorsEdit from './components/Blocks/Sponsors/Edit';
import SponsorsView from './components/Blocks/Sponsors/View';
import VenueEdit from './components/Blocks/Venue/Edit';
import VenueView from './components/Blocks/Venue/View';

import NewsListingBody from './components/Blocks/Listing/NewsListingBody';
import PersonsListingBody from './components/Blocks/Listing/PersonsListingBody';
import PersonsSimpleListingBody from './components/Blocks/Listing/PersonsSimpleListingBody';
import TalksListingBody from './components/Blocks/Listing/TalksListingBody';
import TeaserPersonBody from './components/Blocks/Teaser/TeaserPersonBody';
import DefaultTeaserBody from '@kitconcept/volto-blocks-grid/components/Teaser/DefaultBody';

import calendarSVG from '@plone/volto/icons/calendar.svg';
import heroSVG from '@plone/volto/icons/hero.svg';
import images from '@plone/volto/icons/images.svg';
import listBulletSVG from '@plone/volto/icons/list-bullet.svg';
import sliderSVG from '@plone/volto/icons/slider.svg';
import zoomSVG from '@plone/volto/icons/zoom.svg';

import Keynote from './components/Views/Keynote';
import Person from './components/Views/Person';
import Talk from './components/Views/Talk';
import Training from './components/Views/Training';

import reducers from './reducers';

const applyConfig = (config) => {
  config.settings = {
    ...config.settings,
    isMultilingual: false,
    supportedLanguages: ['en'],
    defaultLanguage: 'en',
    matomoSiteId: '4',
    matomoUrlBase: 'https://stats.ploneconf.org/',
    socialNetworks: [
      {
        id: 'twitter',
        url: 'https://twitter.com/ploneconf',
      },
      {
        id: 'facebook',
        url: 'https://www.facebook.com/PloneConference',
      },
      {
        id: 'youtube',
        url: 'http://youtube.com/c/PloneCMS',
      },
    ],
  };

  config.views.contentTypesViews.Person = Person;
  config.views.contentTypesViews.Talk = Talk;
  config.views.contentTypesViews.Training = Training;
  config.views.contentTypesViews.Keynote = Keynote;

  config.blocks.blocksConfig.teaser.variations = [
    {
      id: 'default',
      isDefault: true,
      title: 'Default',
      template: DefaultTeaserBody,
    },
    {
      id: 'person',
      title: 'Person',
      template: TeaserPersonBody,
    },
  ];

  config.blocks.blocksConfig.listing.variations = [
    ...config.blocks.blocksConfig.listing.variations,
    {
      id: 'persons',
      title: 'Persons',
      template: PersonsListingBody,
    },
    {
      id: 'personsSimple',
      title: 'Persons Simple',
      template: PersonsSimpleListingBody,
    },
    {
      id: 'talks',
      title: 'Talks',
      template: TalksListingBody,
      fullobjects: true,
    },
    {
      id: 'news',
      title: 'News',
      template: NewsListingBody,
    },
  ];

  config.addonReducers = { ...config.addonReducers, ...reducers };

  config.blocks.blocksConfig.cta = {
    id: 'cta',
    title: 'CTA',
    icon: sliderSVG,
    group: 'common',
    view: CTAView,
    edit: CTAEdit,
    restricted: false,
    mostUsed: true,
    sidebarTab: 1,
    security: {
      addPermission: [],
      view: [],
    },
  };
  config.blocks.blocksConfig.sponsorsList = {
    id: 'sponsorsList',
    title: 'Sponsors',
    icon: listBulletSVG,
    group: 'text',
    view: SponsorsEdit,
    edit: SponsorsView,
    restricted: false,
    mostUsed: false,
    sidebarTab: 0,
    security: {
      addPermission: [],
      view: [],
    },
  };
  config.blocks.blocksConfig.paypalBlock = {
    id: 'paypalBlock',
    title: 'PayPal',
    icon: listBulletSVG,
    group: 'text',
    view: PayPalView,
    edit: PayPalEdit,
    restricted: false,
    mostUsed: false,
    sidebarTab: 0,
    security: {
      addPermission: [],
      view: [],
    },
  };
  config.blocks.blocksConfig.fixedBackground = {
    id: 'fixedBackground',
    title: 'Fixed Background',
    icon: images,
    group: 'common',
    view: FixedBackgroundView,
    edit: FixedBackgroundEdit,
    restricted: false,
    mostUsed: true,
    sidebarTab: 1,
    security: {
      addPermission: [],
      view: [],
    },
  };
  config.blocks.blocksConfig.heroImage = {
    id: 'heroImage',
    title: 'Hero Image Advanced',
    icon: heroSVG,
    group: 'common',
    view: HeroImageView,
    edit: HeroImageEdit,
    restricted: false,
    mostUsed: true,
    sidebarTab: 1,
    security: {
      addPermission: [],
      view: [],
    },
  };
  config.blocks.blocksConfig.countdown = {
    id: 'countdown',
    title: 'Countdown',
    icon: heroSVG,
    group: 'common',
    view: CountdownView,
    edit: CountdownEdit,
    restricted: false,
    mostUsed: false,
    blockHasOwnFocusManagement: true,
    sidebarTab: 1,
    security: {
      addPermission: [],
      view: [],
    },
  };
  config.blocks.blocksConfig.venue = {
    id: 'venue',
    title: 'Venue',
    icon: heroSVG,
    group: 'common',
    view: VenueView,
    edit: VenueEdit,
    restricted: false,
    mostUsed: false,
    blockHasOwnFocusManagement: true,
    sidebarTab: 1,
    security: {
      addPermission: [],
      view: [],
    },
  };
  config.blocks.blocksConfig.schedule = {
    id: 'schedule',
    title: 'Schedule',
    icon: calendarSVG,
    group: 'common',
    view: ScheduleView,
    edit: ScheduleEdit,
    restricted: false,
    mostUsed: false,
    blockHasOwnFocusManagement: true,
    sidebarTab: 1,
    security: {
      addPermission: [],
      view: [],
    },
  };
  config.blocks.blocksConfig.nuclia = {
    id: 'nuclia',
    title: 'Nuclia',
    icon: zoomSVG,
    group: 'common',
    view: NucliaView,
    edit: NucliaEdit,
    restricted: false,
    mostUsed: false,
    blockHasOwnFocusManagement: true,
    sidebarTab: 1,
    security: {
      addPermission: [],
      view: [],
    },
  };

  return config;
};

export default applyConfig;
