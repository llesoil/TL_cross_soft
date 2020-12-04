#!/bin/sh

numb='17'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 0.6 --qblur 0.3 --qcomp 0.6 --vbv-init 0.0 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 40 --keyint 210 --lookahead-threads 3 --min-keyint 24 --qp 30 --qpstep 3 --qpmin 2 --qpmax 64 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset faster --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,3.0,1.6,1.1,0.6,0.3,0.6,0.0,1,0,6,40,210,3,24,30,3,2,64,18,3,1000,-2:-2,dia,show,faster,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"