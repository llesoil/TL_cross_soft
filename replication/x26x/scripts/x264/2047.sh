#!/bin/sh

numb='2048'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.1 --pbratio 1.1 --psy-rd 0.2 --qblur 0.6 --qcomp 0.7 --vbv-init 0.2 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 50 --keyint 280 --lookahead-threads 4 --min-keyint 27 --qp 40 --qpstep 3 --qpmin 2 --qpmax 61 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan crop --preset placebo --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,0.0,1.1,1.1,0.2,0.6,0.7,0.2,1,0,4,50,280,4,27,40,3,2,61,38,5,1000,1:1,umh,crop,placebo,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"