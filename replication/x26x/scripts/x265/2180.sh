#!/bin/sh

numb='2181'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 2.2 --qblur 0.2 --qcomp 0.8 --vbv-init 0.2 --aq-mode 1 --b-adapt 1 --bframes 6 --crf 10 --keyint 270 --lookahead-threads 2 --min-keyint 25 --qp 30 --qpstep 4 --qpmin 2 --qpmax 67 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset medium --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.0,1.4,1.1,2.2,0.2,0.8,0.2,1,1,6,10,270,2,25,30,4,2,67,38,6,1000,-2:-2,umh,crop,medium,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"