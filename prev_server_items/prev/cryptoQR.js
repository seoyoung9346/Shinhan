const crypto = require('crypto');
const qrcode = require('qrcode');

const encryptAES256 = (secretKey, plainText) => {
    const keyAsByte = Buffer.from(secretKey, 'utf8');
    const iv = crypto.randomBytes(12);
    const cipher = crypto.createCipheriv('aes-256-ccm', keyAsByte, iv, {authTagLength:16});
    let encrypted = cipher.update(plainText, 'utf8', 'base64');
    encrypted += cipher.final('base64');

    const tag = cipher.getAuthTag();
    return encrypted + "$$" + tag.toString('base64') + "$$" + iv.toString('base64');
}

const decryptAES256 = (secretKey, encrypted) => {
    const keyAsByte = Buffer.from(secretKey, 'utf8');
    const splitted = encrypted.split("$$");

    const body = splitted[0];
    const tag = Buffer.from(splitted[1], 'base64');
    const iv = Buffer.from(splitted[2], 'base64');

    const decipher = crypto.createDecipheriv('aes-256-ccm', keyAsByte, iv, {authTagLength:16});
    decipher.setAuthTag(tag);
    let decrypted = decipher.update(body, 'base64', 'utf8');
    decrypted += decipher.final('utf8');
    return decrypted;
}

const QRkey = 'thisissamplekeyfortestmynewappli'

module.exports = {encryptAES256, decryptAES256, QRkey}