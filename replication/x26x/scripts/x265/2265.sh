#!/bin/sh

numb='2266'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.0 --psy-rd 4.4 --qblur 0.5 --qcomp 0.8 --vbv-init 0.6 --aq-mode 2 --b-adapt 0 --bframes 6 --crf 0 --keyint 250 --lookahead-threads 4 --min-keyint 22 --qp 20 --qpstep 4 --qpmin 0 --qpmax 60 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset fast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.1,1.0,4.4,0.5,0.8,0.6,2,0,6,0,250,4,22,20,4,0,60,38,6,1000,-2:-2,umh,show,fast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"