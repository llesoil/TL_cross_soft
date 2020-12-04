#!/bin/sh

numb='1634'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.3 --pbratio 1.0 --psy-rd 0.2 --qblur 0.3 --qcomp 0.6 --vbv-init 0.8 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 15 --keyint 300 --lookahead-threads 4 --min-keyint 24 --qp 0 --qpstep 4 --qpmin 0 --qpmax 63 --rc-lookahead 38 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset slower --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.0,1.3,1.0,0.2,0.3,0.6,0.8,2,1,4,15,300,4,24,0,4,0,63,38,2,2000,-1:-1,hex,crop,slower,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"