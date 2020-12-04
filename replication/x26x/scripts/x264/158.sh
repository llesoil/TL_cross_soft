#!/bin/sh

numb='159'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 3.0 --ipratio 1.2 --pbratio 1.2 --psy-rd 1.8 --qblur 0.5 --qcomp 0.9 --vbv-init 0.7 --aq-mode 0 --b-adapt 1 --bframes 14 --crf 0 --keyint 220 --lookahead-threads 4 --min-keyint 29 --qp 0 --qpstep 3 --qpmin 3 --qpmax 65 --rc-lookahead 38 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan crop --preset superfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,3.0,1.2,1.2,1.8,0.5,0.9,0.7,0,1,14,0,220,4,29,0,3,3,65,38,2,1000,1:1,hex,crop,superfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"