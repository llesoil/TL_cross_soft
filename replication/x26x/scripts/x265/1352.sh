#!/bin/sh

numb='1353'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.1 --psy-rd 1.4 --qblur 0.4 --qcomp 0.6 --vbv-init 0.9 --aq-mode 1 --b-adapt 1 --bframes 10 --crf 45 --keyint 220 --lookahead-threads 1 --min-keyint 26 --qp 20 --qpstep 4 --qpmin 0 --qpmax 64 --rc-lookahead 18 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset fast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,0.0,1.3,1.1,1.4,0.4,0.6,0.9,1,1,10,45,220,1,26,20,4,0,64,18,4,1000,-2:-2,dia,show,fast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"