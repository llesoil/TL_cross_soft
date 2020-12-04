#!/bin/sh

numb='769'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.4 --psy-rd 3.8 --qblur 0.3 --qcomp 0.8 --vbv-init 0.4 --aq-mode 1 --b-adapt 1 --bframes 4 --crf 20 --keyint 280 --lookahead-threads 3 --min-keyint 23 --qp 10 --qpstep 3 --qpmin 2 --qpmax 69 --rc-lookahead 48 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset superfast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.0,1.5,1.4,3.8,0.3,0.8,0.4,1,1,4,20,280,3,23,10,3,2,69,48,1,1000,-2:-2,umh,crop,superfast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"