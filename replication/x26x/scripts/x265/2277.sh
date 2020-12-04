#!/bin/sh

numb='2278'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.0 --psy-rd 0.8 --qblur 0.4 --qcomp 0.6 --vbv-init 0.6 --aq-mode 3 --b-adapt 0 --bframes 16 --crf 40 --keyint 250 --lookahead-threads 4 --min-keyint 30 --qp 0 --qpstep 3 --qpmin 0 --qpmax 62 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan crop --preset veryfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,0.0,1.1,1.0,0.8,0.4,0.6,0.6,3,0,16,40,250,4,30,0,3,0,62,38,1,2000,1:1,dia,crop,veryfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"