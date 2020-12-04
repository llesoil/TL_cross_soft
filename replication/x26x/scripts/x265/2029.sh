#!/bin/sh

numb='2030'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --constrained-intra --intra-refresh --no-asm --slow-firstpass --weightb --aq-strength 0.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 3.2 --qblur 0.5 --qcomp 0.9 --vbv-init 0.1 --aq-mode 3 --b-adapt 2 --bframes 10 --crf 10 --keyint 290 --lookahead-threads 0 --min-keyint 24 --qp 50 --qpstep 5 --qpmin 3 --qpmax 65 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset faster --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,--intra-refresh,--no-asm,--slow-firstpass,--weightb,0.0,1.3,1.0,3.2,0.5,0.9,0.1,3,2,10,10,290,0,24,50,5,3,65,28,1,1000,1:1,umh,show,faster,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"