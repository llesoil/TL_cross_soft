#!/bin/sh

numb='1481'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 4.0 --qblur 0.6 --qcomp 0.7 --vbv-init 0.3 --aq-mode 1 --b-adapt 0 --bframes 16 --crf 40 --keyint 200 --lookahead-threads 4 --min-keyint 20 --qp 0 --qpstep 3 --qpmin 2 --qpmax 65 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan crop --preset faster --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,3.0,1.3,1.0,4.0,0.6,0.7,0.3,1,0,16,40,200,4,20,0,3,2,65,18,3,1000,1:1,dia,crop,faster,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"