#!/bin/sh

numb='875'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 2.0 --ipratio 1.4 --pbratio 1.1 --psy-rd 2.2 --qblur 0.4 --qcomp 0.8 --vbv-init 0.1 --aq-mode 3 --b-adapt 2 --bframes 6 --crf 20 --keyint 270 --lookahead-threads 2 --min-keyint 28 --qp 40 --qpstep 5 --qpmin 1 --qpmax 63 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset ultrafast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,2.0,1.4,1.1,2.2,0.4,0.8,0.1,3,2,6,20,270,2,28,40,5,1,63,28,1,1000,1:1,umh,show,ultrafast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"