#!/bin/sh

numb='2412'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 1.4 --qblur 0.5 --qcomp 0.7 --vbv-init 0.8 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 45 --keyint 230 --lookahead-threads 4 --min-keyint 21 --qp 50 --qpstep 3 --qpmin 1 --qpmax 65 --rc-lookahead 38 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me hex --overscan crop --preset veryfast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,2.0,1.1,1.1,1.4,0.5,0.7,0.8,0,0,8,45,230,4,21,50,3,1,65,38,4,1000,-2:-2,hex,crop,veryfast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"