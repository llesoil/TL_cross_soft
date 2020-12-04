#!/bin/sh

numb='1861'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.4 --psy-rd 3.6 --qblur 0.4 --qcomp 0.7 --vbv-init 0.1 --aq-mode 1 --b-adapt 2 --bframes 12 --crf 30 --keyint 230 --lookahead-threads 4 --min-keyint 26 --qp 30 --qpstep 3 --qpmin 3 --qpmax 66 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan crop --preset veryslow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,0.5,1.3,1.4,3.6,0.4,0.7,0.1,1,2,12,30,230,4,26,30,3,3,66,48,6,1000,-1:-1,umh,crop,veryslow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"