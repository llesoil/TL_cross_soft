#!/bin/sh

numb='1911'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --constrained-intra --no-asm --weightb --aq-strength 0.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 0.4 --qblur 0.2 --qcomp 0.9 --vbv-init 0.0 --aq-mode 1 --b-adapt 2 --bframes 4 --crf 45 --keyint 260 --lookahead-threads 3 --min-keyint 23 --qp 20 --qpstep 4 --qpmin 4 --qpmax 60 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset ultrafast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,0.5,1.6,1.2,0.4,0.2,0.9,0.0,1,2,4,45,260,3,23,20,4,4,60,48,6,1000,1:1,umh,show,ultrafast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"