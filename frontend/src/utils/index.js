
import { ethers } from "ethers";
import { normalize } from 'eth-ens-namehash';
import { keccak_256 as sha3 } from 'js-sha3';

export const format = (num, digit) => {
  let numFormated = ethers.utils.formatEther(num);
  if (digit) {
    digit = digit + 1
    if (numFormated.length - numFormated.indexOf(".") > digit) {
      numFormated = numFormated.substring(0, numFormated.indexOf(".") + digit);
    } else if (numFormated.indexOf(".") > 0 && numFormated.length - numFormated.indexOf(".") < digit) {
      numFormated = numFormated + "0";
    }
  }
  return ethers.utils.commify(numFormated);
}

export const short = (addr) => {
  return `${addr.substring(
    0,
    6,
  )}...${addr.substring(
    addr.length - 4,
    addr.length,
  )}`;
}

export const namehash = (inputName) => {
  let node = ''
  for (let i = 0; i < 32; i++) {
    node += '00'
  }
  if (inputName) {
    const labels = inputName.split('.');
    for (let i = labels.length - 1; i >= 0; i--) {
      let normalisedLabel = normalize(labels[i])
      let labelSha = sha3(normalisedLabel)
      node = sha3(new Buffer(node + labelSha, 'hex'))
    }
  }
  return '0x' + node
}

export const checkOps = async (addr, dir) => {
  if (!dir) {
    return false;
  }
  const url = `https://explorer.galileo.web3q.io/api?module=account&action=txlist&address=${dir}`;
  try {
    const response = await fetch(url, {
      method: "GET",
    })
    const data = await response.json();
    if (data.status == 1 && data.result) {
      return data.result.some(r => r.from.toLowerCase() === addr.toLowerCase());
    }
  } catch (e) {
    console.error(url, e);
  }
  return false;
}