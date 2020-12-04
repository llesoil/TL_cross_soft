#!/bin/sh

numb='2841'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.1 --pbratio 1.4 --psy-rd 1.0 --qblur 0.2 --qcomp 0.9 --vbv-init 0.7 --aq-mode 3 --b-adapt 2 --bframes 2 --crf 45 --keyint 280 --lookahead-threads 4 --min-keyint 25 --qp 50 --qpstep 3 --qpmin 3 --qpmax 60 --rc-lookahead 38 --ref 1 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan show --preset slower --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--weightb,0.5,1.1,1.4,1.0,0.2,0.9,0.7,3,2,2,45,280,4,25,50,3,3,60,38,1,1000,-1:-1,dia,show,slower,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"