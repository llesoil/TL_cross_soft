#!/bin/sh

numb='2816'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.3 --psy-rd 4.6 --qblur 0.3 --qcomp 0.8 --vbv-init 0.0 --aq-mode 1 --b-adapt 0 --bframes 4 --crf 5 --keyint 300 --lookahead-threads 1 --min-keyint 29 --qp 10 --qpstep 4 --qpmin 4 --qpmax 65 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset faster --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,0.5,1.4,1.3,4.6,0.3,0.8,0.0,1,0,4,5,300,1,29,10,4,4,65,48,6,1000,-2:-2,dia,show,faster,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"