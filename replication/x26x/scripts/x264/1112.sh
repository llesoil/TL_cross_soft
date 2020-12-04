#!/bin/sh

numb='1113'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-asm --slow-firstpass --weightb --aq-strength 3.0 --ipratio 1.5 --pbratio 1.1 --psy-rd 4.6 --qblur 0.4 --qcomp 0.8 --vbv-init 0.3 --aq-mode 1 --b-adapt 2 --bframes 0 --crf 20 --keyint 230 --lookahead-threads 1 --min-keyint 30 --qp 10 --qpstep 3 --qpmin 0 --qpmax 68 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock 1:1 --me hex --overscan show --preset ultrafast --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,--no-asm,--slow-firstpass,--weightb,3.0,1.5,1.1,4.6,0.4,0.8,0.3,1,2,0,20,230,1,30,10,3,0,68,28,2,1000,1:1,hex,show,ultrafast,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"