import message from 'antd/es/message';

import consumer from './consumer';

let hide;
consumer.subscriptions.create('ArchivingProcessChannel', {
  received(data) {
    if (data.status === "finish") {
      if (!hide) {
        hide = message.loading('Preparing to load...', 0);
      }
    }

    if (data.status === "finish") {
      hide && hide();

      const downloadUrl = data.meta && data.meta.url;
      window.open(downloadUrl,'_blank');
    }
  },
});
