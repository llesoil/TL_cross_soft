#!/bin/sh

numb='2625'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --weightb --aq-strength 2.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 3.8 --qblur 0.3 --qcomp 0.9 --vbv-init 0.2 --aq-mode 1 --b-adapt 1 --bframes 6 --crf 30 --keyint 250 --lookahead-threads 4 --min-keyint 21 --qp 50 --qpstep 5 --qpmin 4 --qpmax 68 --rc-lookahead 38 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset ultrafast --scenecut 10 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,None,--weightb,2.0,1.1,1.3,3.8,0.3,0.9,0.2,1,1,6,30,250,4,21,50,5,4,68,38,4,2000,-2:-2,umh,show,ultrafast,10,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"