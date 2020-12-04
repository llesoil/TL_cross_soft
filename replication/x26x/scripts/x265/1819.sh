#!/bin/sh

numb='1820'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 3.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.4 --aq-mode 0 --b-adapt 2 --bframes 12 --crf 5 --keyint 240 --lookahead-threads 4 --min-keyint 24 --qp 10 --qpstep 4 --qpmin 3 --qpmax 65 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset faster --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,--slow-firstpass,--weightb,1.0,1.5,1.4,3.0,0.2,0.6,0.4,0,2,12,5,240,4,24,10,4,3,65,48,6,2000,-1:-1,umh,show,faster,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"