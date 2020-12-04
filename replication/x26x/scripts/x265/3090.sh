#!/bin/sh

numb='3091'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --no-weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 2.2 --qblur 0.3 --qcomp 0.6 --vbv-init 0.1 --aq-mode 2 --b-adapt 0 --bframes 6 --crf 45 --keyint 280 --lookahead-threads 1 --min-keyint 26 --qp 20 --qpstep 5 --qpmin 2 --qpmax 60 --rc-lookahead 48 --ref 4 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset superfast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--no-weightb,2.5,1.6,1.3,2.2,0.3,0.6,0.1,2,0,6,45,280,1,26,20,5,2,60,48,4,1000,-2:-2,umh,show,superfast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"