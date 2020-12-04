#!/bin/sh

numb='1480'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 1.6 --qblur 0.2 --qcomp 0.9 --vbv-init 0.4 --aq-mode 1 --b-adapt 1 --bframes 14 --crf 25 --keyint 300 --lookahead-threads 1 --min-keyint 20 --qp 50 --qpstep 4 --qpmin 2 --qpmax 68 --rc-lookahead 48 --ref 2 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset veryfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.0,1.0,1.3,1.6,0.2,0.9,0.4,1,1,14,25,300,1,20,50,4,2,68,48,2,1000,-2:-2,umh,show,veryfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"