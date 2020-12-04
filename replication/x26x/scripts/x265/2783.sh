#!/bin/sh

numb='2784'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.1 --psy-rd 3.6 --qblur 0.4 --qcomp 0.9 --vbv-init 0.3 --aq-mode 0 --b-adapt 0 --bframes 6 --crf 0 --keyint 280 --lookahead-threads 2 --min-keyint 25 --qp 0 --qpstep 3 --qpmin 0 --qpmax 61 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset veryfast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,1.0,1.6,1.1,3.6,0.4,0.9,0.3,0,0,6,0,280,2,25,0,3,0,61,48,4,1000,-2:-2,umh,show,veryfast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"