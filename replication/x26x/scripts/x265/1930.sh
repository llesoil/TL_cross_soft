#!/bin/sh

numb='1931'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --no-asm --weightb --aq-strength 2.0 --ipratio 1.0 --pbratio 1.2 --psy-rd 2.2 --qblur 0.4 --qcomp 0.6 --vbv-init 0.5 --aq-mode 3 --b-adapt 0 --bframes 2 --crf 30 --keyint 260 --lookahead-threads 2 --min-keyint 30 --qp 40 --qpstep 3 --qpmin 3 --qpmax 69 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset ultrafast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,2.0,1.0,1.2,2.2,0.4,0.6,0.5,3,0,2,30,260,2,30,40,3,3,69,28,3,1000,1:1,dia,crop,ultrafast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"