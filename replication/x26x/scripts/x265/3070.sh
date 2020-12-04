#!/bin/sh

numb='3071'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.0 --pbratio 1.0 --psy-rd 3.6 --qblur 0.2 --qcomp 0.8 --vbv-init 0.2 --aq-mode 2 --b-adapt 0 --bframes 6 --crf 45 --keyint 280 --lookahead-threads 4 --min-keyint 28 --qp 30 --qpstep 3 --qpmin 3 --qpmax 67 --rc-lookahead 38 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset slower --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.0,1.0,3.6,0.2,0.8,0.2,2,0,6,45,280,4,28,30,3,3,67,38,3,1000,1:1,umh,crop,slower,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"