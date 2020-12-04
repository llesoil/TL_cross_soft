#!/bin/sh

numb='2179'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.4 --psy-rd 0.8 --qblur 0.2 --qcomp 0.6 --vbv-init 0.5 --aq-mode 3 --b-adapt 0 --bframes 16 --crf 45 --keyint 290 --lookahead-threads 4 --min-keyint 25 --qp 20 --qpstep 4 --qpmin 4 --qpmax 62 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset faster --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,1.5,1.2,1.4,0.8,0.2,0.6,0.5,3,0,16,45,290,4,25,20,4,4,62,48,6,1000,-2:-2,umh,show,faster,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"