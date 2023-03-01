import { customBlocks } from '@package/components/Blocks';
import { Person, Talk, Keynote, Training } from '@package/components';
import DefaultTeaserBody from '@kitconcept/volto-blocks-grid/components/Teaser/DefaultBody';
import {
  PersonsListingBody,
  PersonsSimpleListingBody,
  TeaserPersonBody,
  TalksListingBody,
  NewsListingBody,
} from '@package/components';


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

  config.blocks = {
    ...config.blocks,
    blocksConfig: { ...config.blocks.blocksConfig, ...customBlocks },
    requiredBlocks: [],
  };
};

export default applyConfig;
