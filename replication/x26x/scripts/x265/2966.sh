#!/bin/sh

numb='2967'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --weightb --aq-strength 1.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 0.2 --qblur 0.6 --qcomp 0.7 --vbv-init 0.4 --aq-mode 2 --b-adapt 1 --bframes 12 --crf 15 --keyint 220 --lookahead-threads 1 --min-keyint 21 --qp 10 --qpstep 4 --qpmin 3 --qpmax 64 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset slower --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,1.0,1.4,1.1,0.2,0.6,0.7,0.4,2,1,12,15,220,1,21,10,4,3,64,28,6,1000,-1:-1,hex,show,slower,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"