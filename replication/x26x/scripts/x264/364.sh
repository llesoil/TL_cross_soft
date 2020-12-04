#!/bin/sh

numb='365'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 2.5 --ipratio 1.0 --pbratio 1.1 --psy-rd 0.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.3 --aq-mode 2 --b-adapt 0 --bframes 8 --crf 50 --keyint 210 --lookahead-threads 2 --min-keyint 29 --qp 10 --qpstep 5 --qpmin 0 --qpmax 68 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset superfast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,2.5,1.0,1.1,0.8,0.4,0.9,0.3,2,0,8,50,210,2,29,10,5,0,68,38,6,1000,1:1,umh,show,superfast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"