#!/bin/sh

numb='407'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.4 --psy-rd 3.8 --qblur 0.2 --qcomp 0.8 --vbv-init 0.0 --aq-mode 3 --b-adapt 2 --bframes 16 --crf 50 --keyint 300 --lookahead-threads 4 --min-keyint 30 --qp 50 --qpstep 5 --qpmin 1 --qpmax 69 --rc-lookahead 38 --ref 5 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset slow --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,3.0,1.1,1.4,3.8,0.2,0.8,0.0,3,2,16,50,300,4,30,50,5,1,69,38,5,1000,1:1,umh,show,slow,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"