#!/bin/sh

numb='1274'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --no-weightb --aq-strength 1.5 --ipratio 1.6 --pbratio 1.2 --psy-rd 1.8 --qblur 0.3 --qcomp 0.9 --vbv-init 0.9 --aq-mode 2 --b-adapt 2 --bframes 16 --crf 15 --keyint 250 --lookahead-threads 4 --min-keyint 24 --qp 40 --qpstep 4 --qpmin 0 --qpmax 68 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset ultrafast --scenecut 0 --tune ssim --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--no-weightb,1.5,1.6,1.2,1.8,0.3,0.9,0.9,2,2,16,15,250,4,24,40,4,0,68,48,4,2000,-2:-2,umh,show,ultrafast,0,ssim,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"