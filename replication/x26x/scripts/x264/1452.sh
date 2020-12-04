#!/bin/sh

numb='1453'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 1.0 --ipratio 1.2 --pbratio 1.4 --psy-rd 4.6 --qblur 0.6 --qcomp 0.6 --vbv-init 0.8 --aq-mode 1 --b-adapt 1 --bframes 12 --crf 45 --keyint 220 --lookahead-threads 2 --min-keyint 20 --qp 50 --qpstep 4 --qpmin 0 --qpmax 63 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset ultrafast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,1.0,1.2,1.4,4.6,0.6,0.6,0.8,1,1,12,45,220,2,20,50,4,0,63,28,3,1000,1:1,umh,show,ultrafast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"