import { DirectUpload } from '@rails/activestorage';

let directUploadUrl;
function getDirectUploadUrl() {
  if (directUploadUrl) {
    return directUploadUrl;
  }

  const metaElement = document.querySelector('meta[name=direct-upload-url]');
  directUploadUrl = metaElement && metaElement.content;

  return directUploadUrl;
}

export class Uploader {
  constructor(file) {
    this.upload = new DirectUpload(file, getDirectUploadUrl(), this)
  }

  uploadFile() {
    this.upload.create((error, blob) => {
      if (error) {
      } else {
      }
    });
  }

  directUploadWillStoreFileWithXHR(request) {
    request.upload.addEventListener('progress',
      event => this.directUploadDidProgress(event));
  }

  directUploadDidProgress(event) {
    console.log(`${event.loaded * 100 / event.total}%`);
  }
}
